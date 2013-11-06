;(require [cucumber.runtime.clj as cuce])
(require '[clojure.data.xml :as xml])
(require '[clj-time.format :as ft])
(require '[clj-time.core :as tm])
(require '[clj-time.coerce :as coerce])
(def payment-groups (atom {}))
(def xml (atom nil))

(defn ppxml [xml]
  (let [in (javax.xml.transform.stream.StreamSource.
            (java.io.StringReader. xml))
        writer (java.io.StringWriter.)
        out (javax.xml.transform.stream.StreamResult. writer)
        transformer (.newTransformer 
                     (javax.xml.transform.TransformerFactory/newInstance))]
    (.setOutputProperty transformer 
                        javax.xml.transform.OutputKeys/INDENT "yes")
    (.setOutputProperty transformer 
                        "{http://xml.apache.org/xslt}indent-amount" "2")
    (.setOutputProperty transformer 
                        javax.xml.transform.OutputKeys/METHOD "xml")
    (.transform transformer in out)
    (-> out .getWriter .toString)))

(defn pain-001-001-03 [message-id debitor-info payment-groups]
  (let [now (ft/unparse (:date-hour-minute-second ft/formatters) (tm/now))]
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
                              (xml/element :CtrlSum {} (format "%.2f" (reduce + (map (fn [a] (reduce + (map (fn [b] (:sum b)) (:payments (last a))))) payment-groups))))
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
                                           (xml/element :Nm {} (:name debitor-info)))
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
                                                                                                        (xml/element :Issr {} "ISO"))
                                                                                           (xml/element :Ref {} (:reference-number payment))))))) (:payments payment-group))))))))

(Given #"^payment group \"([^\"]*)\" with due date \"([^\"]*)\" with pending payments$" [arg1 due-date arg2]
  (swap! payment-groups assoc arg1 {:due-date due-date :payments (table->rows arg2)}))

(When #"^I create payment XML \"([^\"]*)\" with debitor information \"([^\"]*)\" / \"([^\"]*)\" / \"([^\"]*)\" / \"([^\"]*)\" including payment groups$" [message-id arg1 arg2 arg3 arg4 arg5]
  (let [p-groups (map #(:payment-group %) (table->rows arg5))
        x (pain-001-001-03
            message-id
            {:name arg1
             :contract-id arg2
             :iban arg3
             :bic arg4} (select-keys @payment-groups (for [[k v] @payment-groups :when (some #{k} p-groups)] k)))]
    (reset! xml x)))

(defn assert-string-equals [expected actual]
  (try (assert (= expected actual))
       (catch java.lang.AssertionError e
         (spit "expected.txt" expected)
         (spit "actual.txt" actual)
         (let [p (difflib.DiffUtils/diff (clojure.string/split-lines expected) (clojure.string/split-lines actual))]
           (println (str "expected: " expected))
           (println (str "actual: " actual))
           (throw (java.lang.AssertionError. (apply str (map (fn [d] d) (.getDeltas p)))))))))

(Given #"^time is frozen at \"([^\"]*)\"$" [arg1]
       (let [l (coerce/to-long arg1)]
         (org.joda.time.DateTimeUtils/setCurrentMillisFixed l)))

(Then #"^the XML should be$" [arg1]
      (assert-string-equals (ppxml arg1) (ppxml (xml/emit-str @xml))))
