(require '[shared :as s])
(require '[corporate.core :as corp])
(require 'clojure.data)

(Given #"^xml payload:$" [arg1]
  (reset! s/xml-payload arg1))

(When #"^I parse the xml payload as camt.052.001.02$" []
  (reset! s/parsed (corp/camt-052-001-02 @s/xml-payload)))

(Then #"^the result hash map should be$" [arg1]
  (let [exp (read-string arg1)
        sh (= @s/parsed exp)]
    (if (not sh) (println (clojure.data/diff @s/parsed exp)))
    (assert sh)))
