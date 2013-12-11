(require '[shared :as s])
(require '[clojure.data.xml :as xml])

(require '[clj-time.format :as ft])
(require '[clj-time.core :as tm])


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
 
(When #"^I create an account reporting request with following properties$" [arg1]
  (let [data (kv-table->map arg1)
        x (camt-060-001-02 data)]
    (reset! s/xml x)))

