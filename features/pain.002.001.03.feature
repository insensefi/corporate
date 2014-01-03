Feature: pain.002.001.03


  Scenario: Accepted technical check
    Given xml payload:
    """xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.002.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.002.001.03 pain.002.001.03.xsd">
      <CstmrPmtStsRpt>
        <GrpHdr>
          <MsgId>1539869</MsgId>
          <CreDtTm>2010-06-08T12:01:10+03:00</CreDtTm>
        </GrpHdr>
        <OrgnlGrpInfAndSts>
          <OrgnlMsgId>20110102-0000001</OrgnlMsgId>
          <OrgnlMsgNmId>pain.001.001.03</OrgnlMsgNmId>
          <GrpSts>ACTC</GrpSts>
        </OrgnlGrpInfAndSts>
      </CstmrPmtStsRpt>
    </Document>
    """
    When I parse the xml payload as pain.002.001.03
    Then the result hash map should be
    """clojure
    {:original-group-information-and-status {:original-message-identification "20110102-0000001"
                                             :original-message-name-identification "pain.001.001.03"
                                             :group-status "ACTC"}}
    """


