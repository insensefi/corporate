(ns corporate.core
  (:require [clojure.data.xml :as xml]
            [clojure.zip :as zip]
            [clj-time.format :as ft]
            [clj-time.core :as tm]
            [named-re.core])
  (:use [clojure.data.zip.xml :only (text attr xml->)]
        [clojure.data.zip :only (children)]))

(defn pain-002-001-03 [xml-str]
  (let [xml (xml/parse-str xml-str)
        report (first (:content xml))
        zipped (zip/xml-zip report)]
    {:original-group-information-and-status {:original-message-identification (first (xml-> zipped :OrgnlGrpInfAndSts :OrgnlMsgId text))
                                             :original-message-name-identification (first (xml-> zipped :OrgnlGrpInfAndSts :OrgnlMsgNmId text))
                                             :group-status (first (xml-> zipped :OrgnlGrpInfAndSts :GrpSts text))
                                             :status-reason-information (if (seq (xml-> zipped :OrgnlGrpInfAndSts :StsRsnInf children)) {:reason-code (first (xml-> zipped :OrgnlGrpInfAndSts :StsRsnInf :Rsn :Cd text))
                                                                         :additional-information (apply str (xml-> zipped :OrgnlGrpInfAndSts :StsRsnInf :AddtlInf text))})}}))
(defn camt-052-001-02 [xml-str]
  (let [xml (xml/parse-str xml-str)
        report (first (:content xml))
        reports (filter (fn [el] (= (:tag el) :Rpt)) (:content report))]
    {:reports (map (fn [el]
                    (let [zipped (zip/xml-zip el)
                          balances (map (fn [bal-el]
                                         (let [zipped (zip/xml-zip bal-el)]
                                           {:amount (read-string (first (xml-> zipped :Amt text)))
                                            :amount-currency (first (xml-> zipped :Amt (attr :Ccy)))
                                            :date (first (xml-> zipped :Dt :Dt text))
                                            :type (first (xml-> zipped :Tp :CdOrPrtry :Cd text)) })) (filter (fn [e] (= (:tag e) :Bal)) (:content el)))]
                     {:identification (first (xml-> zipped :Id text))
                      :creation-date-time (first (xml-> zipped :CreDtTm text))
                      :account {:iban (first (xml-> zipped :Acct :Id :IBAN text))
                                :account-type-name (first (xml-> zipped :Acct :Tp :Prtry text))
                                :account-owner-name (first (xml-> zipped :Acct :Nm text))
                                :currency (first (xml-> zipped :Acct :Ccy text))}
                      :balances balances        })) reports)}))


(defn pain-001-001-03 [message-id debitor-info payment-groups]
  (let [now (ft/unparse (:date-hour-minute-second ft/formatters) (tm/now))
        df (java.text.DecimalFormat. "#.##" (java.text.DecimalFormatSymbols. java.util.Locale/ENGLISH))]
  (xml/element
    :Document
    {:xmlns "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"
     :xmlns:xsi "http://www.w3.org/2001/XMLSchema-instance"
     :xsi:schemaLocation "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 pain.001.001.03.xsd"}
    (xml/element :CstmrCdtTrfInitn {}
                 (xml/element :GrpHdr {}
                              (xml/element :MsgId {} message-id)
                              (xml/element :CreDtTm {} now)
                              (xml/element :NbOfTxs {} (str (reduce + (map (fn [a] (count (:payments (last a)))) payment-groups))))
                              (xml/element :CtrlSum {} (.format df (reduce + (map (fn [a] (reduce + (map (fn [b] (:sum b)) (:payments (last a))))) payment-groups))))
                              (xml/element :InitgPty {}
                                           (xml/element :Id {}
                                                        (xml/element :OrgId {}
                                                                     (xml/element :Othr {}
                                                                                  (xml/element :Id {} (:contract-id debitor-info))
                                                                                  (xml/element :SchmeNm {}
                                                                                               (xml/element :Cd {} "BANK")))))))
                 (for [[payment-group-id payment-group]  payment-groups]
                   (xml/element :PmtInf {}
                               (xml/element :PmtInfId {} payment-group-id)
                               (xml/element :PmtMtd {} "TRF")
                               (xml/element :ReqdExctnDt {} (:due-date payment-group))
                               (xml/element :Dbtr {}
                                           (xml/element :Nm {} (:name debitor-info))
                                            (xml/element :Id {}
                                                         (xml/element :OrgId {}
                                                                      (xml/element :BICOrBEI {} (:bic debitor-info))
                                                                      (xml/element :Othr {}
                                                                                   (xml/element :Id {} (:contract-id debitor-info))
                                                                                   (xml/element :SchmeNm {}
                                                                                                (xml/element :Cd {} "BANK"))))))
                               (xml/element :DbtrAcct {}
                                           (xml/element :Id {}
                                                       (xml/element :IBAN {} (:iban debitor-info))))
                               (xml/element :DbtrAgt {}
                                           (xml/element :FinInstnId {}
                                                       (xml/element :BIC {} (:bic debitor-info))))
                                (map (fn [payment]
                                       (xml/element :CdtTrfTxInf {}
                                                    (xml/element :PmtId {}
                                                                 (xml/element :EndToEndId {} (:end-to-end-id payment)))
                                                    (xml/element :Amt {}
                                                                 (xml/element :InstdAmt {:Ccy (:currency payment)} (str (:sum payment))))
                                                    (xml/element :CdtrAgt {}
                                                                 (xml/element :FinInstnId {}
                                                                              (xml/element :BIC {} (:bic payment))))
                                                    (xml/element :Cdtr {}
                                                                 (xml/element :Nm {} (:name payment)))
                                                    (xml/element :CdtrAcct {}
                                                                 (xml/element :Id {}
                                                                              (xml/element :IBAN {} (:iban payment))))
                                                    (xml/element :RmtInf {}
                                                                 (xml/element :Strd {}
                                                                              (xml/element :CdtrRefInf {}
                                                                                           (xml/element :Tp {}
                                                                                                        (xml/element :CdOrPrtry {}
                                                                                                                     (xml/element :Cd {} "SCOR"))
                                                                                                        (if (:rf-reference-number payment) (xml/element :Issr {} "ISO")))
                                                                                           (xml/element :Ref {}
                                                                                                        (str (or (:rf-reference-number payment)
                                                                                                            (:reference-number payment))))))))) (:payments payment-group))))))))


(defn camt-060-001-02 [data]
  (let [now (ft/unparse (:date-hour-minute-second ft/formatters) (tm/now))]
   (xml/element
    :Document
    {:xmlns "urn:iso:std:iso:20022:tech:xsd:camt.060.001.02"
     :xmlns:xsi "http://www.w3.org/2001/XMLSchema-instance"
     :xsi:schemaLocation "urn:iso:std:iso:20022:tech:xsd:camt.060.001.02 camt.060.001.02.xsd"}
    (xml/element :AcctRptgReq {}
                 (xml/element :GrpHdr {}
                              (xml/element :MsgId {} (str (:message-identification data)))
                              (xml/element :CreDtTm {} now))
                 (xml/element :RptgReq {}
                              (xml/element :Id {} (:identification data))
                              (xml/element :ReqdMsgNmId {} (:requested-message-name-identification data))
                              (xml/element :Acct {}
                                           (xml/element :Id {}
                                                        (xml/element :IBAN {} (:iban data))))
                              (xml/element :AcctOwnr {}
                                           (xml/element :Pty {}
                                                        (xml/element :Nm {} (:account-owner-name data))))
                              (xml/element :RptgPrd {}
                                           (xml/element :FrToDt {}
                                                        (xml/element :FrDt {} (:from-date data)))
                                           (xml/element :FrToTm {}
                                                        (xml/element :FrTm {} (:from-time data)))
                                           (xml/element :Tp {} (:type data))))))))
 

(defn tito [txt]
  (let [formatter (ft/formatter "yyMMdd")
        date-formatter (:year-month-day ft/formatters)
        lines (clojure.string/split-lines txt)
        header-line (first lines)]
    (if-let [header-raw (dissoc (first (re-seq #"T00.{3}.{3}(?<bban>.{14})(?<statementnumber>.{3})(?<datestart>.{6})(?<dateend>.{6})(?<creationdate>.{6})(?<creationtime>.{4})(?<contractid>.{17}).{31}(?<currency>.{3})(?<accountname>.{30}).{18}(?<accountownername>.{35})(?<bankcontactinformation>.{40})(?<bankcontactinformationdetails>.{40}).*" header-line)) :0)]
      {:header {:bban (:bban header-raw)
                :statement-number (read-string (clojure.string/replace (:statementnumber header-raw) #"^0*" ""))
                :date-start (ft/unparse date-formatter (ft/parse formatter (:datestart header-raw)))
                :date-end (ft/unparse date-formatter (ft/parse formatter (:dateend header-raw)))
                :creation-date (ft/unparse date-formatter (ft/parse formatter (:creationdate header-raw)))
                :creation-time (clojure.string/join ":" (map (partial apply str) (split-at 2 (:creationtime header-raw))))
                :contract-id (clojure.string/trim (:contractid header-raw))
                :currency (:currency header-raw)
                :account-name (clojure.string/trim (:accountname header-raw))
                :account-owner-name (clojure.string/trim (:accountownername header-raw))
                :bank-contact-information (clojure.string/trim (:bankcontactinformation header-raw))
                :bank-contact-information-details (clojure.string/trim (:bankcontactinformationdetails header-raw))}})))


(defn camt-053-001-02 [xml-str]
  (let [xml (xml/parse-str xml-str)
        statement (first (:content xml))
        statements (filter (fn [el] (= (:tag el) :Stmt)) (:content statement))]
    {:statements (map (fn [el]
                        (let [zipped (zip/xml-zip el)
                              entries (map (fn [entry-el]
                                             (let [zipped (zip/xml-zip entry-el)]
                                               {:entry-reference (first (xml-> zipped :NtryRef text))
                                                :amount (read-string (first (xml-> zipped :Amt text)))
                                                :amount-currency (first (xml-> zipped :Amt (attr :Ccy)))
                                                :credit-debit-indicator (first (xml-> zipped :CdtDbtInd text))
                                                :status (first (xml-> zipped :Sts text))
                                                :booking-date (first (xml-> zipped :BookgDt :Dt text))
                                                :value-date (first (xml-> zipped :ValDt :Dt text))
                                                :account-servicer-reference (first (xml-> zipped :AcctSvcrRef text))
                                                :bank-transaction-code {:domain-code (first (xml-> zipped :BkTxCd :Domn :Cd text))
                                                                        :domain-family-code (first (xml-> zipped :BkTxCd :Domn :Fmly :Cd text))
                                                                        :domain-sub-family-code (first (xml-> zipped :BkTxCd :Domn :Fmly :SubFmlyCd text))
                                                                        :proprietary-code (first (xml-> zipped :BkTxCd :Prtry :Cd text))
                                                                        :proprietary-issuer (first (xml-> zipped :BkTxCd  :Prtry :Issr text))}
                                                :entry-details {:transaction-details {:transaction-amount (read-string (first (xml-> zipped :NtryDtls :TxDtls :AmtDtls :TxAmt :Amt text)))
                                                                                      :transaction-amount-currency (first (xml-> zipped :NtryDtls :TxDtls :AmtDtls :TxAmt :Amt (attr :Ccy)))
                                                                                      :bank-transaction-code {:domain-code (first (xml-> zipped :NtryDtls :TxDtls :BkTxCd :Domn :Cd text))
                                                                                                              :domain-family-code (first (xml-> zipped :NtryDtls :TxDtls :BkTxCd :Domn :Fmly :Cd text))
                                                                                                              :domain-sub-family-code (first (xml-> zipped :NtryDtls :TxDtls :BkTxCd :Domn :Fmly :SubFmlyCd text))
                                                                                                              :proprietary-code (first (xml-> zipped :NtryDtls :TxDtls :BkTxCd :Prtry :Cd text))
                                                                                                              :proprietary-issuer (first (xml-> zipped :NtryDtls :TxDtls :BkTxCd  :Prtry :Issr text))}
                                                                                      :related-dates {:acceptance-date-time (first (xml-> zipped :NtryDtls :TxDtls :RltdDts :AccptncDtTm text))}}}})) (filter (fn [e] (= (:tag e) :Ntry)) (:content el)))

                              balances (map (fn [bal-el]
                                              (let [zipped (zip/xml-zip bal-el)]
                                                {:type (first (xml-> zipped :Tp :CdOrPrtry :Cd text))
                                                 :amount (read-string (first (xml-> zipped :Amt text)))
                                                 :amount-currency (first (xml-> zipped :Amt (attr :Ccy)))
                                                 :date (first (xml-> zipped :Dt :Dt text))
                                                 :credit-debit-indicator (first (xml-> zipped :CdtDbtInd text))
                                                 :credit-line {:included (= "true" (first (xml-> zipped :CdtLine :Incl text)))
                                                               :amount (first (xml-> zipped :CdtLine :Amt text))
                                                               :amount-currency (first (xml-> zipped :CdtLine :Amt (attr :Ccy)))} })) (filter (fn [e] (= (:tag e) :Bal)) (:content el)))]
                          {:identification (first (xml-> zipped :Id text))
                           :legal-sequence-number (first (xml-> zipped :LglSeqNb text))
                           :creation-date-time (first (xml-> zipped :CreDtTm text))
                           :from-date-time (first (xml-> zipped :FrToDt :FrDtTm text))
                           :to-date-time (first (xml-> zipped :FrToDt :ToDtTm text))
                           :account {:iban (first (xml-> zipped :Acct :Id :IBAN text))
                                     :account-owner-name (first (xml-> zipped :Acct :Nm text))
                                     :servicer-name (first (xml-> zipped :Acct :Svcr :FinInstnId :Nm text))
                                     :servicer-bic (first (xml-> zipped :Acct :Svcr :FinInstnId :BIC text))
                                     :currency (first (xml-> zipped :Acct :Ccy text))}
                           :transaction-summary {:number-of-entries (read-string (first (xml-> zipped :TxsSummry :TtlNtries :NbOfNtries text)))
                                                 :number-of-credit-entries (read-string (first (xml-> zipped :TxsSummry :TtlCdtNtries :NbOfNtries text)))
                                                 :sum-of-credit-entries (read-string (first (xml-> zipped :TxsSummry :TtlCdtNtries :Sum text)))
                                                 :number-of-debit-entries (read-string (first (xml-> zipped :TxsSummry :TtlDbtNtries :NbOfNtries text)))
                                                 :sum-of-debit-entries (read-string (first (xml-> zipped :TxsSummry :TtlDbtNtries :Sum text)))}
                           :entries entries
                           :balances balances })) statements)}))

