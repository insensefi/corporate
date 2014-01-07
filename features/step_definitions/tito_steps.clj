(require '[corporate.core :as corp])
(require '[shared :as shared])

(def txt (atom nil))

(Given #"^string content$" [arg1]
       (reset! txt arg1))

(When #"^I parse the file as TITO$" []
  (reset! shared/parsed (corp/tito @txt)))
