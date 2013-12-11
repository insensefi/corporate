Feature: camt.060.001.02

Background:
    Given time is frozen at "2013-12-12T00:52:00"
  
  
  Scenario: 'Tapahtumaotekysely' from OP
    When I create an account reporting request with following properties
      | message-identification                | 1302162226915      |
      | identification                        | TAPAHTUMAOTEKYSELY |
      | requested-message-name-identification | camt.052.001.02    |
      | iban                                  | FI2958498520005387 |
      | account-owner-name                    | Oy Yritys Ab       |
      | from-date                             | 2013-12-12         |
      | from-time                             | 00:01:00           |
      | type                                  | ALLL               |
    Then the XML should be
    """xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Document xmlns="urn:iso:std:iso:20022:tech:xsd:camt.060.001.02"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:camt.060.001.02 camt.060.001.02.xsd">
      <AcctRptgReq>
        <GrpHdr>
          <MsgId>1302162226915</MsgId>
          <CreDtTm>2013-12-12T00:52:00</CreDtTm>
        </GrpHdr>
        <RptgReq>
          <Id>TAPAHTUMAOTEKYSELY</Id>
          <ReqdMsgNmId>camt.052.001.02</ReqdMsgNmId>
          <Acct>
            <Id>
              <IBAN>FI2958498520005387</IBAN>
            </Id>
          </Acct>
          <AcctOwnr>
            <Pty>
              <Nm>Oy Yritys Ab</Nm>
            </Pty>
          </AcctOwnr>
          <RptgPrd>
            <FrToDt>
              <FrDt>2013-12-12</FrDt>
            </FrToDt>
            <FrToTm>
              <FrTm>00:01:00</FrTm>
            </FrToTm>
            <Tp>ALLL</Tp>
          </RptgPrd>
        </RptgReq>
      </AcctRptgReq>
    </Document>
    """


