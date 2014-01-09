Feature: camt.052.001.02


  Scenario: Parse xml
    Given xml payload:
    """xml
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <Document xmlns="urn:iso:std:iso:20022:tech:xsd:camt.052.001.02">
      <BkToCstmrAcctRpt>
        <GrpHdr>
          <MsgId>57169012345612345629122013135031385</MsgId>
          <CreDtTm>2013-12-29T13:50:31.385+02:00</CreDtTm>
          <MsgRcpt>
            <PstlAdr>
              <AdrTp>BIZZ</AdrTp>
            </PstlAdr>
            <Id>
              <OrgId>
                <Othr>
                  <Id>asdf</Id>
                  <SchmeNm>
                    <Cd>BANK</Cd>
                  </SchmeNm>
                </Othr>
              </OrgId>
            </Id>
          </MsgRcpt>
        </GrpHdr>
        <Rpt>
          <Id>TAPAHTUMAOTEKYSELY</Id>
          <CreDtTm>2013-12-29T13:50:31+02:00</CreDtTm>
          <Acct>
            <Id>
              <IBAN>FI4819503000000010</IBAN>
            </Id>
            <Tp>
              <Prtry>YRITYSTILI</Prtry>
            </Tp>
            <Ccy>EUR</Ccy>
            <Nm>VALLILAN YRITYS OY</Nm>
            <Ownr>
              <Id>
                <PrvtId>
                  <Othr>
                    <Id>asdf</Id>
                  </Othr>
                </PrvtId>
              </Id>
            </Ownr>
          </Acct>
          <Bal>
            <Tp>
              <CdOrPrtry>
                <Cd>ITBD</Cd>
              </CdOrPrtry>
            </Tp>
            <Amt Ccy="EUR">12345.6</Amt>
            <CdtDbtInd>CRDT</CdtDbtInd>
            <Dt>
              <Dt>2013-12-29</Dt>
            </Dt>
          </Bal>
          <Bal>
            <Tp>
              <CdOrPrtry>
                <Cd>ITAV</Cd>
              </CdOrPrtry>
            </Tp>
            <Amt Ccy="EUR">2234.56</Amt>
            <CdtDbtInd>CRDT</CdtDbtInd>
            <Dt>
              <Dt>2013-12-29</Dt>
            </Dt>
          </Bal>
          <Ntry>
            <Amt Ccy="EUR">72.0</Amt>
            <CdtDbtInd>CRDT</CdtDbtInd>
            <Sts>BOOK</Sts>
            <BookgDt>
              <Dt>2013-12-29</Dt>
            </BookgDt>
            <AcctSvcrRef>201206055UTZ00099326</AcctSvcrRef>
            <BkTxCd>
              <Domn>
                <Cd>PMNT</Cd>
                <Fmly>
                  <Cd>RCDT</Cd>
                  <SubFmlyCd>ESCT</SubFmlyCd>
                </Fmly>
              </Domn>
              <Prtry>
                <Cd>705VIITESIIRTO</Cd>
                <Issr>FFFS</Issr>
              </Prtry>
            </BkTxCd>
            <NtryDtls>
              <TxDtls>
                <RltdPties>
                  <Dbtr>
                    <Nm>REIJO SAVELA</Nm>
                    <Id>
                      <OrgId>
                        <Othr>
                          <Id>0999994-9</Id>
                          <SchmeNm>
                            <Prtry>PrtryId</Prtry>
                          </SchmeNm>
                        </Othr>
                      </OrgId>
                    </Id>
                  </Dbtr>
                </RltdPties>
                <RltdAgts>
                  <CdtrAgt>
                    <FinInstnId>
                      <BIC>OKOYFIHH</BIC>
                    </FinInstnId>
                  </CdtrAgt>
                </RltdAgts>
                <RmtInf>
                  <Strd>
                    <CdtrRefInf>
                      <Tp>
                        <CdOrPrtry>
                          <Cd>SCOR</Cd>
                        </CdOrPrtry>
                      </Tp>
                      <Ref>66666666</Ref>
                    </CdtrRefInf>
                  </Strd>
                </RmtInf>
                <RltdDts>
                  <AccptncDtTm>2013-12-29T00:00:00</AccptncDtTm>
                </RltdDts>
              </TxDtls>
            </NtryDtls>
          </Ntry>
          <Ntry>
            <Amt Ccy="EUR">76.14</Amt>
            <CdtDbtInd>DBIT</CdtDbtInd>
            <Sts>BOOK</Sts>
            <BookgDt>
              <Dt>2013-12-29</Dt>
            </BookgDt>
            <AcctSvcrRef>20120615SV0047184</AcctSvcrRef>
            <BkTxCd>
              <Domn>
                <Cd>PMNT</Cd>
                <Fmly>
                  <Cd>RDDT</Cd>
                  <SubFmlyCd>PMDD</SubFmlyCd>
                </Fmly>
              </Domn>
              <Prtry>
                <Cd>704SUORAVELOITUS</Cd>
                <Issr>FFFS</Issr>
              </Prtry>
            </BkTxCd>
            <NtryDtls>
              <TxDtls>
                <RltdPties>
                  <Cdtr>
                    <Nm>MALLILAN ISÄNNÖINTI</Nm>
                  </Cdtr>
                </RltdPties>
                <RmtInf>
                  <Strd>
                    <CdtrRefInf>
                      <Tp>
                        <CdOrPrtry>
                          <Cd>SCOR</Cd>
                        </CdOrPrtry>
                      </Tp>
                      <Ref>00349191060007001007</Ref>
                    </CdtrRefInf>
                  </Strd>
                </RmtInf>
                <RltdDts>
                  <AccptncDtTm>2013-12-29T00:00:00</AccptncDtTm>
                </RltdDts>
              </TxDtls>
            </NtryDtls>
          </Ntry>
          <Ntry>
            <Amt Ccy="EUR">1206.29</Amt>
            <CdtDbtInd>DBIT</CdtDbtInd>
            <Sts>BOOK</Sts>
            <BookgDt>
              <Dt>2013-12-29</Dt>
            </BookgDt>
            <AcctSvcrRef>20120629123456</AcctSvcrRef>
            <BkTxCd>
              <Domn>
                <Cd>PMNT</Cd>
                <Fmly>
                  <Cd>ICDT</Cd>
                  <SubFmlyCd>XBCT</SubFmlyCd>
                </Fmly>
              </Domn>
              <Prtry>
                <Cd>770ULKOMAANMAKSU</Cd>
                <Issr>FFFS</Issr>
              </Prtry>
            </BkTxCd>
            <NtryDtls>
              <TxDtls>
                <AmtDtls>
                  <InstdAmt>
                    <Amt Ccy="NOK">1720.66</Amt>
                    <CcyXchg>
                      <SrcCcy>NOK</SrcCcy>
                      <TrgtCcy>EUR</TrgtCcy>
                      <UnitCcy>EUR</UnitCcy>
                      <XchgRate>0.7600000</XchgRate>
                    </CcyXchg>
                  </InstdAmt>
                  <TxAmt>
                    <Amt Ccy="EUR">1206.29</Amt>
                  </TxAmt>
                  <CntrValAmt>
                    <Amt Ccy="EUR">1206.29</Amt>
                    <CcyXchg>
                      <SrcCcy>EUR</SrcCcy>
                      <TrgtCcy>EUR</TrgtCcy>
                      <UnitCcy>EUR</UnitCcy>
                      <XchgRate>1.0000000</XchgRate>
                    </CcyXchg>
                  </CntrValAmt>
                </AmtDtls>
                <RltdPties>
                  <Cdtr>
                    <Nm>VALLILAN YRITYS OY</Nm>
                  </Cdtr>
                </RltdPties>
                <RltdAgts>
                  <CdtrAgt>
                    <FinInstnId>
                      <BIC>NDEANOKK</BIC>
                    </FinInstnId>
                  </CdtrAgt>
                </RltdAgts>
                <RmtInf>
                  <Strd/>
                </RmtInf>
                <RltdDts>
                  <AccptncDtTm>2013-12-29T00:00:00</AccptncDtTm>
                </RltdDts>
              </TxDtls>
            </NtryDtls>
          </Ntry>
        </Rpt>
      </BkToCstmrAcctRpt>
    </Document>
    """
    When I parse the xml payload as camt.052.001.02
    Then the result hash map should be
    """clojure
    {:reports ({:identification "TAPAHTUMAOTEKYSELY"
                :creation-date-time "2013-12-29T13:50:31+02:00"
                :account {:iban "FI4819503000000010"
                          :account-type-name "YRITYSTILI"
                          :account-owner-name "VALLILAN YRITYS OY"
                          :currency "EUR"}
                :balances ({:amount 12345.6
                            :amount-currency "EUR"
                            :type "ITBD"
                            :date "2013-12-29"}
                           {:amount 2234.56
                            :amount-currency "EUR"
                            :type "ITAV" 
                            :date "2013-12-29"})})}
    """

                 

