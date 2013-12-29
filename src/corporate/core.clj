(ns corporate.core
  (:require [clojure.data.xml :as xml]
            [clojure.zip :as zip]
            [clj-time.format :as ft]
            [clj-time.core :as tm])
  (:use [clojure.data.zip.xml :only (text attr xml->)]))

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
 
