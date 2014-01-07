Feature: TITO

  Scenario: Parse header information from a TITO file

    Given string content
    """
    T00322100195030000000100440603060603060603062359    44444444     060303+000000000000440927000064EURShekkitili                    000000000000000000POHJANLINNAN RAUTATALO             Nordea Pankki Suomi Oyj Y-tunn 1680235-81950 Demokonttori                                                     FI4819503000000010 NDEAFIHH   
    T101880000010303A2584SM07002490603060603060603061710Maksum{{r{ys                       +000000000001550300  JOKOHAMA LTD                       A                                            
    T11148002584SMM0829720                     MAKSAJAN ILMOITTAMA SAAJAN NIMI:   IRONHOUSE                          NC POHJANL                         
    T1104905+000000000001302992 EUR 00011898000      
    T1114807L[HETT[J[N OSOITE:                 JOKOHAMA LTD                       351 (8 FL)BOSS Z2,SNOWLAKE OFFICE AABB JOKOHAMA IRONSTREET 129 BXY 17 
    T101880000020306A2584SM01001450603060603060603061710Nordea Payment                     +000000000001087700  SAN PEDRO'S STEEL                  A                                            
    T11288002584SMM0850240                     /RFB/12347/8985122027              ATM.PMT. NR 001113658697           ALKUP. M[[R[ USD         10 885,00 ULKOMAISEN PANKIN KULUT USD    8,00MAKSAJAN ILMOITTAMA SAAJAN NIMI:   IRONHOUSE FI                       POHJANLINNA FINLAD                 
    T1104905+000000000000913726 EUR 00011904000      
    T1114807L[HETT[J[N OSOITE:                 PEDRO'S STEEL                      PARADISESTR.114 OFI 45 AVE PRINCIP 1071 VENEZUELA                     
    T101880000030603061950AA0201010603060603070603061710Pano                               +000000000000000585 KVIRTANEN LIISA                     J                                            
    T1104300ASENNUSLASKU 15/2006               
    T101880000040603038R10000999950603060603060603031710Pano                               +000000000000022768 AKANGAS JA TILKKU                   J                                            
    T11041021111111111 222222222222222 060208
    T101880000050603061950AA0201030603060603070603061710Pano                               +000000000000005850 KVIRTANEN LIISA                     J                                            
    T1104300ASENNUSLASKU 15/2006               
    T101880000060603062588723A76460603060603070603061710Vakuutuskorvaus                    +000000000000087238 AVAKUUTUS OY                        J                                            
    T1107800Vak.Oy/M Virta     240974080C      010101010                          
    T101880000070603062588777A03420603060603070603061710Pano                               +000000000000285870 ALUOTTOKORTTIYHTI\                  J                                            
    T1104300LUOTTOKORTTITILITYKSET ER[ 7852UE  
    T10188000008060306258874B630990603060603070603061703Maksup{{tepalvelu                  +000000000000077100 ARAUTAKESKUS 1                      J                                            
    T110160100000020
    T1107800OSTOT     20 KPL             771,00OIK.       0 KPL               0,00
    T11043060001134                            
    T101880000090603062584SM0200420603060603060603061780Zero Balancing                     +000000000000343519 KABC KONSERNI                       J                                            
    T1107800CMZ/0098780003                     /8285                              
    T101880000100603062588790100010603060603060603062720Verkkopankki                       -000000000001974696 AKUPARIKESKUS                       J19503000018210                              
    T110430600000003595986000555               
    T101880000110603062588790100050603060603060603062720Verkkopankki                       -000000000000022715 ARUUVI JA MUTTERI                   J19503000018343                              
    T110430600025000365020217315               
    T101880000120603032584LV1315310603060603060603062720Maksum{{r{ys                       -000000000000202583 ABINGEN'S STEEL&WOOD                A                                     123456 
    T1121800BBFAS                              8227 CH                            1252684213                         CRESCHZZ5BB                        35845257305056590078               2223338887                         
    T11043060000000025059610                   
    T1114807MAKSAJAN LIS[TIEDOT:               IRONHOUSE PMT CNTR                 Lis{palkkio:                       Saajan IBAN-tili puuttuu           
    T1104309ALTMANNSTR.999                     
    T101880000130603062584LV1481870603060603060603062720EU-maksu                           -000000000000580111 AEESTI METALL                       A                                     123854 
    T1118300EESTI                              99999 EE                           EE382200221020145685               FOREEE2Y                           260130                             
    T11043060000000025009216                   
    T101880000140603061950AA0201020603060603070603063710Pano korjaus                       -000000000000000585 KVIRTANEN LIISA                     J                                            
    T11026040603061950AA020101
    T101880000150603061950AA1212120603060603060603062720K{teisnosto                        -000000000000080000 K                                                                                
    T1104307Ville Virta                        
    T101880000160603062950AA0000770603060603060603062721Korttiosto                         -000000000000002150 APOHJANLINNAN TAXI                  J                                            
    T11043034920291234567891209 0606039875421  
    T10188000017060306258877A303690603060603060603062702Laskujen maksupalvelu              -000000000000069555EA                                                                                
    T110160100000002
    T110430611122278                           
    T1104309HENKIL\ST\OSASTO                   
    T10188000017                  0603060000000603062702Maksu                              -000000000000010000 AMERISINI OYJ                       J29501800069357 00000000000000000013        1
    T1107806123456                             7890                               
    T10188000017                  0603060000000603062702Maksu                              -000000000000059555 APOUTAPILVI TMI                     J19503000009540 00000000000012345672        1
    T1107806654321                             0987                               
    T10188000018060306258873D510320603060603060603062704Suoraveloitus                      -000000000000037338 APOHJANLINNAN SANOMAT               J29501800068417                              
    T110430600000000005397010481               
    T10188000019                  0603060603060000001705Viitepanot                         +000000000000213200E                                                                                 
    T110160100000005
    T10188000020                  0603060603070000001705Viitepanot                         +000000000000563000E                                                                                 
    T110160100000014
    T10188000021                  0603060603070000003705Viitepanojen korjaus               -000000000000003300E                                                                                 
    T110160100000002
    T40050060306+000000000001705024+000000000000000000
    T50067106030600000011+00000000000423713000000010-000000000002973033
    T51067106030600000000+00000000000000000000000002-000000000000003885
    T50067306030600000000+00000000000969342000000000-000000000012494489
    T50067406030600000000+00000000002976714800000000-000000000022845789
    """
    When I parse the file as TITO
    Then the result hash map should be
    """clojure
    {:header {:bban "19503000000010"
              :statement-number 44
              :date-start "2006-03-06"
              :date-end "2006-03-06"
              :creation-date "2006-03-06"
              :creation-time "23:59"
              :contract-id "44444444"
              :currency "EUR"
              :account-name "Shekkitili"
              :account-owner-name "POHJANLINNAN RAUTATALO"
              :bank-contact-information "Nordea Pankki Suomi Oyj Y-tunn 1680235-8"
              :bank-contact-information-details "1950 Demokonttori"}}
    """
