;(require [cucumber.runtime.clj as cuce])
(require '[clj-time.coerce :as coerce])
(require '[corporate.core :as corp])
(require '[clojure.data.xml :as xml])
(require '[shared :as shared])
(def payment-groups (atom {}))

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

(Given #"^payment group \"([^\"]*)\" with due date \"([^\"]*)\" with pending payments$" [arg1 due-date arg2]
  (swap! payment-groups assoc arg1 {:due-date due-date :payments (table->rows arg2)}))

(When #"^I create payment XML \"([^\"]*)\" with debitor information \"([^\"]*)\" / \"([^\"]*)\" / \"([^\"]*)\" / \"([^\"]*)\" including payment groups$" [message-id arg1 arg2 arg3 arg4 arg5]
  (let [p-groups (map #(:payment-group %) (table->rows arg5))
        x (corp/pain-001-001-03
            message-id
            {:name arg1
             :contract-id arg2
             :iban arg3
             :bic arg4} (select-keys @payment-groups (for [[k v] @payment-groups :when (some #{k} p-groups)] k)))]
    (reset! shared/xml x)))

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
      (assert-string-equals (ppxml arg1) (ppxml (xml/emit-str @shared/xml))))


(When #"^I parse the xml payload as pain.002.001.03$" []
  (reset! s/parsed (corp/pain-002-001-03 @s/xml-payload)))
