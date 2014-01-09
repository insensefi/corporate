(ns corporate.core-test
  (:require [clojure.test :refer :all]
            [clojure.data]
            [corporate.core :refer :all]))

(deftest camt53-test
  (testing "Parse"
    (let [data (slurp "camt53.xml")
          expected {:statements [{:identification "TI0107.122005810.1"
                        :legal-sequence-number "003"
                        :creation-date-time "2014-01-03T22:00:00+02:00"
                        :from-date-time "2014-01-03T00:00:00+02:00"
                        :to-date-time "2014-01-03T00:00:00+02:00"
                        :account {:iban "FI1557169020004185"
                                  :currency "EUR"
                                  :account-owner-name nil
                                  :servicer-name "TURUN SEUDUN OSUUSPANKKI"
                                  :servicer-bic "OKOYFIHH"}
                        :balances [{:type "OPBD"
                                    :credit-line {:included false
                                                  :amount nil
                                                  :amount-currency nil}
                                    :amount 1001159.23
                                    :amount-currency "EUR"
                                    :credit-debit-indicator "CRDT"
                                    :date "2014-01-02"}
                                   {:type "PRCD"
                                    :credit-line {:included false
                                                  :amount nil
                                                  :amount-currency nil}
                                    :amount 1001159.23
                                    :amount-currency "EUR"
                                    :credit-debit-indicator "CRDT"
                                    :date "2014-01-02"}
                                   {:type "CLBD"
                                    :credit-line {:included false
                                                  :amount nil
                                                  :amount-currency nil}
                                    :amount 1000000.00
                                    :amount-currency "EUR"
                                    :credit-debit-indicator "CRDT"
                                    :date "2014-01-03"}
                                   {:type "CLAV"
                                    :credit-line {:included true
                                                  :amount "1000000.00"
                                                  :amount-currency "EUR"}
                                    :amount 2000000.00
                                    :amount-currency "EUR"
                                    :credit-debit-indicator "CRDT"
                                    :date "2014-01-03"}]
                        :transaction-summary {:number-of-entries 1
                                              :number-of-credit-entries 1
                                              :sum-of-credit-entries 1159.23
                                              :number-of-debit-entries 0
                                              :sum-of-debit-entries 0.0}
                        :entries [{:entry-reference "000001"
                                   :amount 1159.23
                                   :amount-currency "EUR"
                                   :credit-debit-indicator "CRDT"
                                   :status "BOOK"
                                   :booking-date "2014-01-03"
                                   :value-date "2014-01-03"
                                   :account-servicer-reference "140103578800012359"
                                   :bank-transaction-code {:domain-code "PMNT"
                                                           :domain-family-code "RCDT"
                                                           :domain-sub-family-code "DMCT"
                                                           :proprietary-code "710TILISIIRTO"
                                                           :proprietary-issuer "FFFS"}
                                   :entry-details {:transaction-details {:transaction-amount 1159.23
                                                                         :transaction-amount-currency "EUR"
                                                                         :bank-transaction-code {:domain-code "PMNT"
                                                                                                 :domain-family-code "RCDT"
                                                                                                 :domain-sub-family-code "DMCT"
                                                                                                 :proprietary-code "710TILISIIRTO"
                                                                                                 :proprietary-issuer "FFFS"}
                                                                         :related-dates {:acceptance-date-time "2014-01-03T00:00:00+02:00"}}}}]}]}]
      (is (= expected (camt-053-001-02 data))))))

                         
