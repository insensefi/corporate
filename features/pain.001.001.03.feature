Feature: pain.001.001.03

Background:
    Given time is frozen at "2013-11-01T23:59:00"
  
  
  Scenario: One SEPA payment with finnish national reference
    Given payment group "2013-11-01-G1" with due date "2013-11-15" with pending payments
      | end-to-end-id             | name           | iban               | bic           | sum    | currency | reference-number |
      | 2013-11-01-134123412      | John Doe       | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | 11112            |
    When I create payment XML "2013-11-01-P1" with debitor information "Oy Company Ab" / "87654321" / "FI8529501800030574" / "NDEAFIHH" including payment groups
      | payment-group |
      | 2013-11-01-G1 |
    Then the XML should be
    """xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 pain.001.001.03.xsd">
      <CstmrCdtTrfInitn>
        <GrpHdr>
          <MsgId>2013-11-01-P1</MsgId>
          <CreDtTm>2013-11-01T23:59:00</CreDtTm>
          <NbOfTxs>1</NbOfTxs>
          <CtrlSum>100.01</CtrlSum>
          <InitgPty>
            <Id>
              <OrgId>
                <Othr>
                  <Id>87654321</Id>
                  <SchmeNm>
                    <Cd>BANK</Cd>
                  </SchmeNm>
                </Othr>
              </OrgId>
            </Id>
          </InitgPty>
        </GrpHdr>
        <PmtInf>
          <PmtInfId>2013-11-01-G1</PmtInfId>
          <PmtMtd>TRF</PmtMtd>
          <ReqdExctnDt>2013-11-15</ReqdExctnDt>
          <Dbtr>
            <Nm>Oy Company Ab</Nm>
          </Dbtr>
          <DbtrAcct>
            <Id>
              <IBAN>FI8529501800030574</IBAN>
            </Id>
          </DbtrAcct>
          <DbtrAgt>
            <FinInstnId>
              <BIC>NDEAFIHH</BIC>
            </FinInstnId>
          </DbtrAgt>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123412</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>John Doe</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                  </Tp>
                  <Ref>11112</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
        </PmtInf>
      </CstmrCdtTrfInitn>
    </Document>
    """


Scenario: One SEPA payment with international RF reference
    Given payment group "2013-11-01-G1" with due date "2013-11-15" with pending payments
      | end-to-end-id             | name           | iban               | bic           | sum    | currency | rf-reference-number |
      | 2013-11-01-134123412      | John Doe       | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | RF81123453       |
    When I create payment XML "2013-11-01-P1" with debitor information "Oy Company Ab" / "87654321" / "FI8529501800030574" / "NDEAFIHH" including payment groups
      | payment-group |
      | 2013-11-01-G1 |
    Then the XML should be
    """xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 pain.001.001.03.xsd">
      <CstmrCdtTrfInitn>
        <GrpHdr>
          <MsgId>2013-11-01-P1</MsgId>
          <CreDtTm>2013-11-01T23:59:00</CreDtTm>
          <NbOfTxs>1</NbOfTxs>
          <CtrlSum>100.01</CtrlSum>
          <InitgPty>
            <Id>
              <OrgId>
                <Othr>
                  <Id>87654321</Id>
                  <SchmeNm>
                    <Cd>BANK</Cd>
                  </SchmeNm>
                </Othr>
              </OrgId>
            </Id>
          </InitgPty>
        </GrpHdr>
        <PmtInf>
          <PmtInfId>2013-11-01-G1</PmtInfId>
          <PmtMtd>TRF</PmtMtd>
          <ReqdExctnDt>2013-11-15</ReqdExctnDt>
          <Dbtr>
            <Nm>Oy Company Ab</Nm>
          </Dbtr>
          <DbtrAcct>
            <Id>
              <IBAN>FI8529501800030574</IBAN>
            </Id>
          </DbtrAcct>
          <DbtrAgt>
            <FinInstnId>
              <BIC>NDEAFIHH</BIC>
            </FinInstnId>
          </DbtrAgt>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123412</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>John Doe</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                    <Issr>ISO</Issr>
                  </Tp>
                  <Ref>RF81123453</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
        </PmtInf>
      </CstmrCdtTrfInitn>
    </Document>
    """

Scenario: Multiple SEPA payments with same due date with international RF reference
    Given payment group "2013-11-01-G1" with due date "2013-11-15" with pending payments
      | end-to-end-id             | name           | iban               | bic           | sum    | currency | rf-reference-number |
      | 2013-11-01-134123412      | John Doe       | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | RF81123453       |
      | 2013-11-01-134123413      | John Doe jr    | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | RF81123453       |
      | 2013-11-01-134123414      | Chuck Norris   | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | RF81123453       |
    When I create payment XML "2013-11-01-P1" with debitor information "Oy Company Ab" / "87654321" / "FI8529501800030574" / "NDEAFIHH" including payment groups
      | payment-group |
      | 2013-11-01-G1 |
    Then the XML should be
    """xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 pain.001.001.03.xsd">
      <CstmrCdtTrfInitn>
        <GrpHdr>
          <MsgId>2013-11-01-P1</MsgId>
          <CreDtTm>2013-11-01T23:59:00</CreDtTm>
          <NbOfTxs>3</NbOfTxs>
          <CtrlSum>300.03</CtrlSum>
          <InitgPty>
            <Id>
              <OrgId>
                <Othr>
                  <Id>87654321</Id>
                  <SchmeNm>
                    <Cd>BANK</Cd>
                  </SchmeNm>
                </Othr>
              </OrgId>
            </Id>
          </InitgPty>
        </GrpHdr>
        <PmtInf>
          <PmtInfId>2013-11-01-G1</PmtInfId>
          <PmtMtd>TRF</PmtMtd>
          <ReqdExctnDt>2013-11-15</ReqdExctnDt>
          <Dbtr>
            <Nm>Oy Company Ab</Nm>
          </Dbtr>
          <DbtrAcct>
            <Id>
              <IBAN>FI8529501800030574</IBAN>
            </Id>
          </DbtrAcct>
          <DbtrAgt>
            <FinInstnId>
              <BIC>NDEAFIHH</BIC>
            </FinInstnId>
          </DbtrAgt>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123412</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>John Doe</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                    <Issr>ISO</Issr>
                  </Tp>
                  <Ref>RF81123453</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123413</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>John Doe jr</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                    <Issr>ISO</Issr>
                  </Tp>
                  <Ref>RF81123453</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123414</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>Chuck Norris</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                    <Issr>ISO</Issr>
                  </Tp>
                  <Ref>RF81123453</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
        </PmtInf>
      </CstmrCdtTrfInitn>
    </Document>
    """

Scenario: Multiple SEPA payments with different due date with international RF reference
    Given payment group "2013-11-01-G1" with due date "2013-11-15" with pending payments
      | end-to-end-id             | name           | iban               | bic           | sum    | currency | rf-reference-number |
      | 2013-11-01-134123412      | John Doe       | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | RF81123453       |
    Given payment group "2013-11-01-G2" with due date "2013-11-10" with pending payments
      | end-to-end-id             | name           | iban               | bic           | sum    | currency | rf-reference-number |
      | 2013-11-01-134123413      | John Doe jr    | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | RF81123453       |
      | 2013-11-01-134123414      | Chuck Norris   | FI6329501800020582 | BANKFIHH      | 100.01 | EUR      | RF81123453       |
    When I create payment XML "2013-11-01-P1" with debitor information "Oy Company Ab" / "87654321" / "FI8529501800030574" / "NDEAFIHH" including payment groups
      | payment-group |
      | 2013-11-01-G1 |
      | 2013-11-01-G2 |
    Then the XML should be
    """xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 pain.001.001.03.xsd">
      <CstmrCdtTrfInitn>
        <GrpHdr>
          <MsgId>2013-11-01-P1</MsgId>
          <CreDtTm>2013-11-01T23:59:00</CreDtTm>
          <NbOfTxs>3</NbOfTxs>
          <CtrlSum>300.03</CtrlSum>
          <InitgPty>
            <Id>
              <OrgId>
                <Othr>
                  <Id>87654321</Id>
                  <SchmeNm>
                    <Cd>BANK</Cd>
                  </SchmeNm>
                </Othr>
              </OrgId>
            </Id>
          </InitgPty>
        </GrpHdr>
        <PmtInf>
          <PmtInfId>2013-11-01-G1</PmtInfId>
          <PmtMtd>TRF</PmtMtd>
          <ReqdExctnDt>2013-11-15</ReqdExctnDt>
          <Dbtr>
            <Nm>Oy Company Ab</Nm>
          </Dbtr>
          <DbtrAcct>
            <Id>
              <IBAN>FI8529501800030574</IBAN>
            </Id>
          </DbtrAcct>
          <DbtrAgt>
            <FinInstnId>
              <BIC>NDEAFIHH</BIC>
            </FinInstnId>
          </DbtrAgt>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123412</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>John Doe</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                    <Issr>ISO</Issr>
                  </Tp>
                  <Ref>RF81123453</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
        </PmtInf>
        <PmtInf>
          <PmtInfId>2013-11-01-G2</PmtInfId>
          <PmtMtd>TRF</PmtMtd>
          <ReqdExctnDt>2013-11-10</ReqdExctnDt>
          <Dbtr>
            <Nm>Oy Company Ab</Nm>
          </Dbtr>
          <DbtrAcct>
            <Id>
              <IBAN>FI8529501800030574</IBAN>
            </Id>
          </DbtrAcct>
          <DbtrAgt>
            <FinInstnId>
              <BIC>NDEAFIHH</BIC>
            </FinInstnId>
          </DbtrAgt>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123413</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>John Doe jr</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                    <Issr>ISO</Issr>
                  </Tp>
                  <Ref>RF81123453</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
          <CdtTrfTxInf>
            <PmtId>
              <EndToEndId>2013-11-01-134123414</EndToEndId>
            </PmtId>
            <Amt>
              <InstdAmt Ccy="EUR">100.01</InstdAmt>
            </Amt>
            <CdtrAgt>
              <FinInstnId>
                <BIC>BANKFIHH</BIC>
              </FinInstnId>
            </CdtrAgt>
            <Cdtr>
              <Nm>Chuck Norris</Nm>
            </Cdtr>
            <CdtrAcct>
              <Id>
                <IBAN>FI6329501800020582</IBAN>
              </Id>
            </CdtrAcct>
            <RmtInf>
              <Strd>
                <CdtrRefInf>
                  <Tp>
                    <CdOrPrtry>
                      <Cd>SCOR</Cd>
                    </CdOrPrtry>
                    <Issr>ISO</Issr>
                  </Tp>
                  <Ref>RF81123453</Ref>
                </CdtrRefInf>
              </Strd>
            </RmtInf>
          </CdtTrfTxInf>
        </PmtInf>
      </CstmrCdtTrfInitn>
    </Document>
    """
