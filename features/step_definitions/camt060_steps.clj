(require '[shared :as s])

(require '[corporate.core :as corp])


(When #"^I create an account reporting request with following properties$" [arg1]
  (let [data (kv-table->map arg1)
        x (corp/camt-060-001-02 data)]
    (reset! s/xml x)))

