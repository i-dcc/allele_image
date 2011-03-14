require 'test_helper'

class TestImage < Test::Unit::TestCase
  context "an Image" do
    setup do
      @input = <<GENBANK_DATA
LOCUS       allele_44372_OTTMUSE00000345825_L1L2_Bact_P        38059 bp    dna     linear   UNK 
ACCESSION   unknown
DBSOURCE    accession design_id=44372
COMMENT     cassette : L1L2_Bact_P
COMMENT     design_id : 44372
FEATURES             Location/Qualifiers
     primer_bind     complement(10450..10499)
                     /label=G5
                     /type="G5"
                     /note="G5"
     primer_bind     15002..15051
                     /label=U5
                     /type="U5"
                     /note="U5"
     exon            6761..6918
                     /db_xref="ens:ENSMUSE00000130855"
                     /label=ENSMUSE00000130855
                     /note="ENSMUSE00000130855"
     exon            7101..7256
                     /db_xref="ens:ENSMUSE00000317081"
                     /label=ENSMUSE00000317081
                     /note="ENSMUSE00000317081"
     exon            7932..8079
                     /db_xref="ens:ENSMUSE00000130780"
                     /label=ENSMUSE00000130780
                     /note="ENSMUSE00000130780"
     exon            12606..12839
                     /db_xref="ens:ENSMUSE00000130802"
                     /label=ENSMUSE00000130802
                     /note="ENSMUSE00000130802"
     exon            12997..13170
                     /db_xref="ens:ENSMUSE00000130849"
                     /label=ENSMUSE00000130849
                     /note="ENSMUSE00000130849"
     exon            13685..13832
                     /db_xref="ens:ENSMUSE00000130775"
                     /label=ENSMUSE00000130775
                     /note="ENSMUSE00000130775"
     LRPCR_primer    8461..8485
                     /type="GF4"
                     /label=GF4
                     /note="GF4"
     LRPCR_primer    9063..9086
                     /type="GF1"
                     /label=GF1
                     /note="GF1"
     LRPCR_primer    8461..8488
                     /type="GF3"
                     /label=GF3
                     /note="GF3"
     LRPCR_primer    8465..8488
                     /type="GF2"
                     /label=GF2
                     /note="GF2"
     misc_feature    10450..15051
                     /label=5 arm
                     /note="5 arm"
     primer_bind     15052..15071
                     /label=R1 primer
                     /note="R1 primer"
     gateway         complement(15079..15091)
                     /label=Gateway R1
                     /note="Gateway R1"
     gateway         complement(15079..15091)
                     /label=B1
                     /note="B1"
     primer_bind     complement(15053..15072)
                     /label=R1R primer
                     /note="R1R primer"
     promoter        20222..20742
                     /label=human beta actin promoter
                     /note="human beta actin promoter"
     polyA_site      19904..20159
                     /label=SV40 pA
                     /note="SV40 pA"
     polyA_site      21760..22003
                     /label=SV40 pA
                     /note="SV40 pA"
     gateway         15092..15103
                     /type="L1"
                     /label=Gateway L1 site
                     /note="Gateway L1 site"
     gateway         22123..22133
                     /type="L2"
                     /label=Gateway L2 site
                     /note="Gateway L2 site"
     misc_feature    20768..21753
                     /label=neomycin resistance
                     /note="neomycin resistance "
     SSR_site        22020..22067
                     /label=FRT
                     /note="FRT"
     SSR_site        22074..22107
                     /label=loxP
                     /note="loxP"
     misc_feature    16039..16040
                     /label=en-2 exon
                     /note="en-2 exon"
     SSR_site        15116..15163
                     /label=FRT
                     /note="FRT"
     misc_feature    15164..16038
                     /label=en-2 intron
                     /note="en-2 intron"
     SSR_site        20163..20196
                     /label=loxP site
                     /note="loxP site"
     misc_feature    16252..16812
                     /label=ECMV IRES
                     /note="ECMV IRES"
     misc_feature    16817..19876
                     /label=lacZ
                     /note="lacZ"
     primer_bind     16197..16216
                     /label=IRES5for primer
                     /note="IRES5for primer"
     primer_bind     complement(16122..16141)
                     /label=en2intronbound3
                     /note="en2intronbound3"
     primer_bind     16705..16724
                     /label=3IRES5
                     /note="3IRES5"
     primer_bind     17485..17504
                     /label=LacZCla5
                     /note="LacZCla5"
     primer_bind     20618..20637
                     /label=betact5
                     /note="betact5"
     primer_bind     20937..20956
                     /label=neoPstI_5
                     /note="neoPstI_5"
     primer_bind     21274..21292
                     /label=neoSphI_5
                     /note="neoSphI_5"
     primer_bind     21567..21586
                     /label=neoBstB1_5
                     /note="neoBstB1_5"
     LRPCR_primer    complement(15232..15255)
                     /type="LAR3"
                     /label=LAR3_1
                     /note="LAR3_1"
     LRPCR_primer    19974..19997
                     /type="RAF5"
                     /label=RAF5
                     /note="RAF5"
     LRPCR_primer    21818..21841
                     /type="RAF5"
                     /label=RAF5
                     /note="RAF5"
     primer_bind     22000..22020
                     /label=PNF seq primer
                     /note="PNF seq primer"
     primer_bind     15939..15960
                     /label=FCHK2
                     /note="FCHK2"
     gateway         22134..22146
                     /label=Gateway R2
                     /note="Gateway R2"
     primer_bind     complement(22154..22173)
                     /label=R2 primer
                     /note="R2 primer"
     gateway         22134..22146
                     /label=B2
                     /note="B2"
     primer_bind     22154..22173
                     /label=R2R primer
                     /note="R2R primer"
     primer_bind     complement(22174..22223)
                     /label=U3
                     /type="U3"
                     /note="U3"
     primer_bind     22880..22929
                     /label=D5
                     /type="D5"
                     /note="D5"
     exon            22564..22712
                     /db_xref="ens:ENSMUSE00000317038"
                     /label=ENSMUSE00000317038
                     /note="ENSMUSE00000317038"
     LRPCR_primer    22572..22595
                     /type="EX52"
                     /label=EX52
                     /note="EX52"
     LRPCR_primer    complement(22655..22684)
                     /type="EX32"
                     /label=EX32
                     /note="EX32"
     misc_feature    22174..22929
                     /label=target region
                     /note="target region"
     SSR_site        22953..22986
                     /label=loxP
                     /note="loxP"
     primer_bind     22930..22952
                     /label=Forward primer
                     /note="Forward primer"
     primer_bind     complement(22987..23009)
                     /label=Reverse primer
                     /note="Reverse primer"
     primer_bind     complement(22987..23006)
                     /label=LR primer
                     /note="LR primer"
     primer_bind     22987..23006
                     /label=LRR primer
                     /note="LRR primer"
     primer_bind     complement(23010..23059)
                     /label=D3
                     /type="D3"
                     /note="D3"
     primer_bind     28074..28123
                     /label=G3
                     /type="G3"
                     /note="G3"
     exon            23647..23754
                     /db_xref="ens:ENSMUSE00000130774"
                     /label=ENSMUSE00000130774
                     /note="ENSMUSE00000130774"
     exon            26962..27318
                     /db_xref="ens:ENSMUSE00000130768"
                     /label=ENSMUSE00000130768
                     /note="ENSMUSE00000130768"
     exon            30329..30400
                     /db_xref="ens:ENSMUSE00000130790"
                     /label=ENSMUSE00000130790
                     /note="ENSMUSE00000130790"
     LRPCR_primer    complement(29454..29481)
                     /type="GR4"
                     /label=GR4
                     /note="GR4"
     LRPCR_primer    complement(29457..29486)
                     /type="GR3"
                     /label=GR3
                     /note="GR3"
     LRPCR_primer    complement(29433..29456)
                     /type="GR2"
                     /label=GR2
                     /note="GR2"
     LRPCR_primer    complement(28809..28832)
                     /type="GR1"
                     /label=GR1
                     /note="GR1"
     misc_feature    23010..28123
                     /label=3 arm
                     /note="3 arm"
BASE COUNT     9636 a   8610 c   9068 g  10745 t
ORIGIN      
        1 atcaagctta tgcaacaact taagttcttc ctcattgtaa gtaataccag attaccgctg
       61 gtagaaaata cctatgttac catgctgaca ccatattgtg ttctttggct ttacgcattt
      121 gccctgattt atggcttgta ctaacaggtg gcatgggaat gtgagttgac atgggtcggt
      181 tttcccaggg tggcatgctt gtcaggaggg ctttggattg ctcccggggg aatgattcct
      241 ggtccctgac cattgcaggg caagcacatt gtgccctgtc agcagattgg cagtctggag
      301 ggagacgggc agcccaggca ttcagtggct gtgcatgcag taggtgtgtg aactatgaca
      361 aatgccaaga tggcaaacgt aagatggtaa atgtagtaaa acaaagggaa gagctctgtg
      421 tgctgtgggt cagctgtctc tttatctttc cagctaggca cgtgagtgca ggtctttgac
      481 ctctagctgt gtttaggcag aatccggact tttgttcctt tttagctctg cagtgtctct
      541 atcccctcct cctccttgcc tcagtagtaa ggtgttcagt atgtgcgact cacacagctg
      601 cagagcaggc aaaactggtg gcagcatctt cttattggtg tcttgccacc tccctgtccc
      661 ctttggaaaa gccactgctg cagtacctgt gcctgtggct gggcatctgg ccactgagga
      721 cctttgatac ctgtggggaa ccctgggttc ctttctcagc actgcagaaa cctagtgtgg
      781 tggtcatgcc tgtagtctga gcactggagg tggacacagg aggatcaaga gtttaaggtc
      841 atacgtggct gcatattagt catgatcagc tttggctact tgagacccca tttaaaaaat
      901 tacttctgaa aaggatttaa agaattataa cattaaaaaa aatgacctca taaatccctt
      961 ctttcagagt agtgtgtact gtctactact tactgcctca gctacctcag ctacctcagc
     1021 tacctcagtg ctactgacat tgtggcataa aggatttttg ttgtggggtg gtcctgtgca
     1081 gtgtagaatg tccaccaact ttcctgcctc tgcctagaac agctagcagc actctgtact
     1141 ggtgacagct acgcatgtct ctaaatattc tctggaaaaa caaaacaaaa ccaccctcac
     1201 ttgagaactg tgtgcatcgc ccagttatag tagctgccag ccacacgtgg ttcttaaaca
     1261 tttgaaatat ttggaaactg agcttgcccc aagaacaaaa tactaaattt taccacagaa
     1321 aacagtccct catgaagaaa atcccaataa tgttatagtg atcgtatgtt aaaaaggtgg
     1381 tccttttcat gatgtgttaa gtaaaagatg tgaaaatgtt ctctctactc taaaagaatt
     1441 tcagcttgca tgaacaggcg tagattgagg cttgtgctgt ctgtctgtct gtctgacagc
     1501 actgagctgc agtgacagca tgctgtgatt taaccgtgat tctgccattc gagctctgga
     1561 agctgttggg tgtgaatggt ttcccctgct ttggaaatgt tcctctatac aatgaaattg
     1621 tggagctgta tatccagagg tattattctt ccggtggctg aggctcagtt aggcatctca
     1681 cagtgtgctc ttgtttaaac ccccctgttg gtattgggtt gctctctgtt ttgattaagg
     1741 tagtttttat tacagtagtt gtatcttgag tttcagttta tgtttcttgt tggtgacagt
     1801 gtgtttctac tttcttatat ccttatcctt tacaatacta tttatacata gtagaccctt
     1861 aattaagaac ctactcagtg gatagacatt ttttcagaga aagtctaccg atataaacgc
     1921 attagctatc tatatctcca tttaacttta tgccctttag tgttaatttt aatttaataa
     1981 cttttttgtt tgtttgtttt ttgttttttt gagacagggt ttctctgtgt agccctggct
     2041 gtcctggaac tcactctgta gaccaggctg accttgaact cagaaatcca cctgcctctg
     2101 actcccgagc tctgggatta aaggcgtgtg ccaccacgcc tggctcctgg tttttatttt
     2161 tatatgtaaa cccatccatc catcttacct ttgatacatt tttgactttg gggggtaagt
     2221 ggaagctctc tcccattcag cttaagctac tatttaattt tcttccattt acttaatcat
     2281 tttaatgtaa cctgttaggc ttaattccac atgtgttact gttctgtgac gaacaggcct
     2341 ctccctggtt catttccatt tcaatccatt caaccgcaga ctgtaaagaa tttacagcta
     2401 atagagtctt cttctgcagt agtagtaggt acgtgttcta aatagttagt aatgaagtta
     2461 actgtggcag actgagtagc tgtgcaattg ttagggtttt cattctttag tcttgtccta
     2521 ctgatggagt gtagtctata taatcaagaa agagcaaagt gaataattat ttattacatt
     2581 attttcttag ggctcctatt gctgtgataa aacaaaagca aaacaaaaga aacaacaaac
     2641 aaaaaacaaa ataaaagcct attctgacca gagtcaactt ggggagaaaa agggagaaca
     2701 cttgtagttt gtcatccaag gaagtcaggg caggatctca aggcaggagc ttagaggcca
     2761 tgcctggtgc tctgtctgct tccttatact agcccagggg gcacctcctg ctgtgggcta
     2821 agtcctcaca catacatcag tcaagaaaat gttccaaggt ttacccacag gacagtctgg
     2881 tgggagcatt atctcaattg aggttcccct gatagaatga ctatatcctg tgtcaggttg
     2941 acttaaaagc ttgccagcac tactgttaat cgatcataag caaagtttta agtgacaagt
     3001 acaagtacaa gtggagtggg tagaaatctc tctagtgatt tactagatag cattggatgc
     3061 ttggttgtgc tgctggtgag gcgacctttg actttccaat aacaggtgcc aggttctgta
     3121 tgcaaacgct ctgcaggcat gcctagtggc cggaccctgt gtcacacatg cagtggtgta
     3181 gatgtgcggg atacttagtg gatggatgac tgagggccag ataacctaag gaaggaggaa
     3241 ataatcgagg tgttgccctt gatcgaaagg taatatatag atcctgtgta ttaaatgtct
     3301 gctaagcact tacgtaacct tatctgcttt cagcatggtg cagttcacac acaagtaaat
     3361 gtgagcactg aagctcacag tgtggcagta acaggctaaa ggctggtggc agggtcagca
     3421 ttcaatccac acctgccttg ccttctaaaa cccatgttca aaacctctgc atggtacagt
     3481 cggacccttc aagtctgtaa gagaaaatgg ttttattata gtgcaggaac tcttttctct
     3541 gagtgttttg ttctctgtct gtctgtcttt ccctcccttc cttccttcct tccttccttc
     3601 cttccttcct tccttccttc cttccttcct tccttttttt aatgttagca ttctaaagct
     3661 cttgccagaa tctaaggctc tgttgctctg tgtttggacg aggtctgtct ctgaagctcc
     3721 ctgctgccta tgtgcagcag gaccctgagt ccttctattc cattctcctc ccgtgacatg
     3781 ggcagaacat gtagcatacc agggctgacc ctctggaaac tgtctgtgaa agagaatcag
     3841 atgtggagca acagcagcaa attttaagtt tttagataaa aaatgtgttg tataatttaa
     3901 gtttaggact ccctgttttc ttattacata agatattaca tactactatt attacatatt
     3961 acataccact attattacat actactatta ttacatatta attatatact actattacac
     4021 aggataagtc agcttatgat ggcttgcctt tgtcagggca agattttaga gagtccacgt
     4081 tctaaaacct tagccttcgt gtcatgcatc ggatgccact gtggcactag acaaccctca
     4141 gcaaatggtc ttgcttgcca gttctcgttc aaagtttttt tgagtttggt aatctgcctg
     4201 tacagaaaat aacataacac tggaagatat gggacatatc attaaatgtg atcacagaaa
     4261 caaaacccat gccatcaggt ttatttattt atttattaaa ttgtttggtt ttctagtaac
     4321 agctttttaa aaaacaaaaa acaaaaaaca aaaatacctg tcagtaggca ttttacattt
     4381 aattttagcc aaaggccagg atgtgattta ttactattta ttattatgtt attgttattg
     4441 ttattattgt tattattttt gatgaagcaa atgaaatgaa tgggttgtaa acatcagcac
     4501 tctcatgctc tcttcccatc atccagaaca gtcttaaata tcagaagcgc tcaggaacta
     4561 attgttacaa gatggaggta aaagaggtga cggttctagt tttctcttag tgctgatgcc
     4621 ttatggaagt gtactagtgg atggcacact gcattgctag ttttatgtca acaagctaga
     4681 gtcgttaggt aacaggaggc tcaactgaga aaataccctt caacagcttg tattatgggt
     4741 gagcctgatt agtgatagat gtagaaaggc ccggttcatt gtggacagtg tcatgtctgg
     4801 actggtgggc ctggttgctg taagaaagta ggctgagcaa gtcataggca agttaacaaa
     4861 ttcaaattac agagcgagcc aataaacaac actcctctat ggcctctgtg tcagttttta
     4921 cttccaggtt cctgctttta gttcctgtcc tgatttccct ggatgacaga ctataaggtt
     4981 tgtggtggtt tgagtgacgt tggccccata ggctcatata tttgaatatt tggctcccag
     5041 ttggtggagt ctttagtaag gactagaaag tatgctctta ttagaagaga tgtgtgattg
     5101 tttgaatgaa agtggctcca gtaggcacat agggagtgac attactatga ggtggtgtgg
     5161 ctttgttgga gttaagtgtg gtgttgttgg agatggtgtc ttacttactg tgcgtgagct
     5221 ttgagggttc aaacggtcaa accaggcaga ggggctttcg cctcaagctc tttctgtcag
     5281 cctgcaggct accacgattc ctgccctgac aataatggac taaacatcta aaccagtaag
     5341 gcagtcccaa ttaaaatgtc ttcctttata ggagtagcca tggtaataat gtgtcttctc
     5401 aacaatagaa accctaacaa aggtgcccta actaggagta gactttgagg tttcaaaaga
     5461 ctgtcccagg cccagctccc cacggtctct gtttcctatt tgtggatcag gatgtgagct
     5521 ctcagttatt ccccagtgcc atgtatacct gccatgatgc tcatggactc accctctgga
     5581 actctcagca aactcctgat taaatgcttt tttataagtt gccttggtca tgatgtctct
     5641 tctcagcaat agaacagtaa ctacaataag ctgtaagctg aagtaaacac agcgcttctc
     5701 aagatgaacc atctcaggga ctatatattt tggactgaga atgttggggt agttgggtgg
     5761 gcaacctgct gaacacccat gctgtactct tcttttgctg atgagagagg gagacaggac
     5821 atcccggctc tcatggttag ttgggactga ctttgaaatt ttgtaataga aaactagcaa
     5881 tataattttc agttattggt gaaaggatta actttcagta tatgactctc aggaaaaaga
     5941 agatcaaata tttgatttta aaaatcattt atctttgtgt gtggctccag ggaattattc
     6001 agggctttct gtgctctttc ctcccttctg ctaaagatca aacctagggt ctcatgtatt
     6061 ctagggaagt actctaccat tggactatat ccctagccca tgataaaaga tttgagttat
     6121 aaaaaattta tgttttgaat gtataacaca aagaatgaac ctagtgtaat gtggattcca
     6181 gttactgtgt cagcactggc ctgtcgatgt aacacttgta ccatcttatg ggagatctaa
     6241 cataggagaa ggaggtggag gtgatggcac agatatgaga actatacttt gcacttcatt
     6301 ctacaaacct aaaaaaacct cgtatgtatg tgtttggttg aatgttcttt tttttttaat
     6361 ttttatttat ttattatagc tctcttcggc cccattctct ccaaagattg attgattgat
     6421 tatatgtaag tacactgtag ctgtcttcag acacaccaca agagagcatc agatctcatt
     6481 atagatggtt gtgagccacc atgtggttgc tgggatttga actcaggacc ttcagaagag
     6541 cagtcagtgc tcttaacctc tgagccatct ctcagcacac cccccatttg aatattcttt
     6601 aatgggttct tagcatgcag gtttagtgtc tagccctgtg tcctagggtt ttccagtgct
     6661 gatggagtgg tttgctcctg gtgtattttg agttgtagtc agctagattt agctctcttc
     6721 tctctatatt aattctcctt aactgttctc cccatcacag ttggaatgcc aagatgctct
     6781 cgaaacagca gcccgagttg aggggctttc cctggatatc tctgtgcatt ctcatctcca
     6841 aattctggac gaggagcatt ctaagggaaa ataccaccat ggtttaagtg tcctgaagcc
     6901 cttccggacc actaccaagt aaggctttgt tggctgatgt ttcatatgca aagcactaag
     6961 agcagttttg aaatctcagg ctaaagcgag aacagctagt ggggaccaac atttgtcaag
     7021 aactgtttac taagggtgtt tctcacttat gctcaaatct ctgtgtgtgt tgacacctcg
     7081 tggttggact tctcctctag gcaccagcac ccagtggaca atgctggact tttctcctac
     7141 atgacctttt catggctctc tcctctggcc cgagtggttc acaagaaggg ggagctgtta
     7201 atggaggatg tgtggccttt gtccaagtat gagtcttctg atgtgaacag cagaaggtag
     7261 gcgtctctgg tccaccctat atatactggg tgctaggcct gagctagtgg gtgggccagc
     7321 agtgtggaat ctaaagctcc acacccatta agaacttcag ctgagggtgg gctacctgtg
     7381 gactctcttc cctttgcctt atctctgttt ccctctaatt gtgttttaac caagggcttt
     7441 cactctctca gtctctttct caatctctct ctctctctct ctctctctct ctcagcccca
     7501 cttctagaac tttctgtgcc tccagggaga tattgttgct gccttgtgac acaatacatt
     7561 tttggtggta gctgattgtc tgattaaagt ctagtttgta gctttgcatt ttattacagg
     7621 atccttcaga aagggttggt gcccttgcca aaggaagttt tcatccacaa actttattca
     7681 gggagagacc tttgaggagc ggaagtaaag gctcctgctc ttcttgtgtt ttgtatttca
     7741 gatatcccct tttgggagtc aatacacata ggccaggaag ggagtttttc tgtacaagat
     7801 gtaggctatg tgcataattt tgaaggagag atttgtgtat gcaacaatag aacctgcgat
     7861 ggcaggaagg gggctaggat gtgtcctttc cctggggaga tgtgtaacac aggacatgtg
     7921 cccttgttaa gactagagag actgtggcaa gaagagctga atgaagttgg gccagacgct
     7981 gcctccctgc gaagggttgt gtggatcttt tgccgcacca ggctcatcct gtccatcgtg
     8041 tgcctgatga tcacgcagtt ggctggcttc agtggaccag taagttctga ctatcctttc
     8101 tgaacatctc cagacccggc catggccagc tctaaccttg tttttcggtt gtagaggtaa
     8161 tgataatttt tgagctagtt agcagcctta aatatacttc tagggctatt gaatagggtg
     8221 agtggatttg ggagtgaacg gtggcttgtc agctagactg ttaagaacaa agagctgcag
     8281 aagaagaaac tgctggcttg ttgtcctggg gctgcacaaa tctgaatgga tcctggttcc
     8341 acacagctcc tgcttgttga ttaagtgctg ccatgaacag ccacgtcttg gcagtactgc
     8401 gagcgagtaa gctgagcgtt gtgtggctcg ggctagcaag cctatgttgg tgacgtacca
     8461 gatgcctgga ggcatagttg ctatgttgac tgactctgta accaatgatc cctcaagaag
     8521 ctagaagtct accaggggtt ttgagagtct gtttcaagtt ttacatatag cgttaactgt
     8581 ggcagatttg gggcgaccgc tgtggtttct accaagcctg tgtggattca gtgtagtagc
     8641 taagggagct ttgggcagga ggagttttcg gggcatcctt tcttgcattt ctctgtgctg
     8701 cctgacactt gagattgtga ttgaatttat tctctacata tttgccttga ggcatcggag
     8761 cagtagtact gtttaactgt gcgttttccg tgtgtgggta agctggaggt tcatggtggg
     8821 taagtatgtg tctaagatgc atggtgacta ggtgacacta atttacactt tggaggtttt
     8881 ttgtttttta ttttgttttt cttcttttta atgtatgatc tttaaagaaa aaaaagtttt
     8941 ggtattaggt ttcttaattg accaactaac acttttatat aagttttaaa taaaagagac
     9001 catgtaactg aaatgttatt agccaaaatg gcacgtgttt catagagcca gcattccccc
     9061 aagaagagct tctgtcattg tatcactaca gagctggtgg ctgctctgac acttcgcaca
     9121 gttccttcat ctgggtagta cagaatttct caataatata atgggctttc ttaattcttt
     9181 atttccccat ttctttaaaa aaaatcctgg attgcaggga taaagttttt actccacaaa
     9241 aagtaattgc aaaatgcatg ctcactttga tgccttgaag gtcattcctt tgagcatctg
     9301 ttaagttgtt aatctttcaa ttctgatgca gcaaccggga tgctaacttc tagagactgc
     9361 ttctagatgc ccgtggagag ctgggtgcct tcccataaca ggaactcagg cacatctccc
     9421 tctgctgccg ttttgggaag aaccctgggg agtcaatagg cctagagagc tgtgggcttg
     9481 tctgttgtct ttttgtgaaa cagatatgca agtataaaca atgtagacat ctttttttgg
     9541 aaccctaatc ccaataaatt cttttgactg gaaattggag aatcaggctg gttttgacaa
     9601 aagaaatgaa attaacatta gcagtgagca aacctgtgag tccttctgag gaaatccaat
     9661 gttagatttt gcacactttc taaattgggc atgattttca gattggctca ttctgttctt
     9721 accaatatct tagcctaaat tgtacactcc atacatggga catcccatta ggtcttgttg
     9781 agccttggtg gtcatacata gaacaaatga aacacagtca ggctgtattt atgtgcatta
     9841 ttttttaaaa atttggtcag ttgatactga ccccagaaca gtgtggcaac caacactcct
     9901 gctttatgtc aggtgcctca ggttcaggaa agttctagca cagtgccacc atttataagg
     9961 gtactggcca tactcaaaat gcagaaccaa atcactgcaa ttatatagat gctttggggc
    10021 ccttcttaga ctaagttagt tttagaagtc caggcctgac ccaggacttg tgtctggaga
    10081 gttagcaccc accctagact tgctagagaa ggctgctgtc tgcagtgcca tctcttagtg
    10141 agcgctaact ctgctccagg ccttgtgggg aaagggcact gggaagcctt gagagaggta
    10201 agttcccacc ctccagcctg tctccagcca cagcttgctc catgctgtca ggatctggac
    10261 ttggggggag tgtctctgta gtgggaccag tgacagaagc tgttctttag aattttcagg
    10321 atggctgtat tctgcggtca gaatgagaga gtcaagctgg gcagaatctc tcgccaagag
    10381 ctcaggtaag gtaatgttta ttcactggga atgccttccc cagcaagaca gctatgctga
    10441 cagtcttcag tttcctccca gttagcttag acataaatga taaacttacg actttaaaaa
    10501 aaaaactgaa tttgtttgaa tttttcatgt aaaactgctt ttctttcccc catacgagct
    10561 catttgaaat gccgttgctt tttaaagccc tgtgttggat atgtgttacc tctgtcatct
    10621 tttccccttg gaaagtttcg catagtgcaa acacacccat gtctttcacc ttcccttctc
    10681 ctctctggga gggcctgatt gcttatccag tgctgccaag ggggcaccct aaggtatagg
    10741 aaaggaagga gcccaaacag cacccgctgc cctgggagac tgctccacac tgctgccctg
    10801 tgtggggaaa tgcttcactg caggccttcc tactgagttg catcactaca ggaggcgagg
    10861 ctttggcctc gtgacccagt tccacagttt ggatgcatac tggaaaagaa accaatcttc
    10921 ttgctagtta atctatgcag tgaggaccaa acatgggttc taaaaattct gcaggagggt
    10981 aaaggtggat tgcagtagtt ctcagaatct gaaatccccc atttgatcag gttatttact
    11041 ggggcttgac atgacccaag agacctccta ggacattagt aaacaatttg gtattaagtt
    11101 actttcataa aaactgaaag agactattta ccccagaaac ctggcttccg gaattcagcg
    11161 ttaggcacta caggctggcc catctgtctc tgttgtatgc catttagtat cttacagctg
    11221 cagacagaat tccttactga aggaaccagg gtagatgggt gcatgagttt aatttctttt
    11281 ttcctttaag gtgggtactg gtttggcttt cttttgttat ggtttggttt gatttttgcc
    11341 aacctcaatt ttagctacca ggactcgaaa agactccgaa ggatgccagc atccttgccc
    11401 agcaggccta gaatctcgca gtctgtcggg agcagagtgt ttcctcgcag cttagcgtgc
    11461 caacagcact tgcagtttta agcagagtac ctctttaggg aaattttagt tgttgttgtt
    11521 tttttttttt tttttttttt tttttcttct ccttaatctt ctttcttcag cagcaaggtc
    11581 tttattgcta gagactctac ttcattgcag ctttgggatt ccctcctcgg tgaaagctgc
    11641 catcctgatg cattgtactc cagactctgg aagcagatat ggctctgcca tgcatttcct
    11701 ctactgtgta tagttgcaag tgggaggcca gcccatctgt gtgatggcta tccccgttcg
    11761 gctctgtatg ttcccaccaa atgttcctga tgcccctgct aatgtacagt gtttgtgaga
    11821 tgctctttga acatggtatc tttaaatata tatttcattt tcaataaaag tacactgctt
    11881 cccacttcct ggtatttact gctgttgctg aatgtgcctg tgtgagtgtg tgctccggcg
    11941 ttgcaggacc tcagagctgg aggtgacact cgtggtttct gggggctggc tgtcttccct
    12001 ccctgcaggt ggtgttagac ataagctacc tgaggtaaca tgtttttgtt tttgagaggg
    12061 agtgggcgtg gggagggcca gagggagggt ctctggagtt tggtagcttg tattgtttgc
    12121 tctcttctgt cctattaaac tgcccctgtt tgtttgcagg gatgttttgc acttcccact
    12181 cttccgtaca actgtaggta cactgttcct ttttatcgaa taagcacgtg tgaaagggta
    12241 cagagaaagg tctcggtttc atgtaaagag aggtagccat gtgtgaagat gctggagtaa
    12301 ggtcaatata tacctttgga tgaccatgcg tttagaatgc attgcagctc atgggcaggt
    12361 ttatgttaca ttagaaagag tagtggtcac gatggcgccc ttcagaagaa aagcaagtga
    12421 ccccgctgtc cttcacctgg gggcagattg ccgggaatat ttggtccaac aacacagttt
    12481 ctctttgctt acacactgat cactgtccgt ggagcagcct gctctttcta acctaacata
    12541 acactgtggc tttgtgtggg gttaccgtgg gcgatgttga ctgtggtgtg tgtttctccc
    12601 tgtaggcctt cgtggtgaag cacctcttgg agtacaccca ggcaacagag tctaacctgc
    12661 agtacagctt gctgttagtg ttaggcctac tcctgacaga agttgtacgc tcctggtcac
    12721 ttgcactgac ttgggcattg aattatcgaa ctggtgtccg gttgcggggg gctatcctga
    12781 ctatggcatt caagaagatc ctgaagttaa agaacattaa agaaaagtcc ctaggggagg
    12841 tgagttcaga gcctgtgctt tgttctcaga gcaacccaga gcagactctc agcctgagtt
    12901 cctcctttcc ttggtccctg ctctgacctt gacctttctc ctgaatatag tggcctatgt
    12961 cctacacgct ccctcactat ttgtcatttc ttacagctca tcaatatctg ctccaatgat
    13021 gggcaaagga tgtttgaggc agccgctgtg ggcagcttgc tggctggagg acctgttgtt
    13081 gccatcttgg gcatgattta taatgtaatc atcctaggac ccacgggctt cctgggatca
    13141 gcggttttta tcctctttta tccagcaatg gtgagtgagc ctcttggctg tatcatggta
    13201 gcatcttcat atgggataca taaagtactt gtactgggtt gaagaaagag gatagacgac
    13261 ttctcaaaga aggtagttgg taaagtctga tgctagatag tgctcagttc acctgagcat
    13321 aattttaact tgggaggaag taaggagtca tttgcataaa agaccatagc caactgaagg
    13381 cagagggagt gtgggtggag cagaaggctc taggtgaacc caccccgaga caaaactgga
    13441 gctactgggg ctgacatggt ggcaccagtg tctgtgagat ctgaccagta attgtcttca
    13501 tcgccctaca aggagatgag gattaaatat tttctaactc taaagacccc tttagttaaa
    13561 caacagcaca accatgtgaa atcatgtttg tcccaggaac aggctctgtg cccgtttggc
    13621 tgagaccatt gtgaggcagg tcctgaggtg cttcagtctg atagggcgct gctttccctt
    13681 ccagatgttc gtgtcacggc taactgcata tttcaggaga aagtgtgtag ctgccacaga
    13741 tgaccgtgtc cagaagatga atgaagttct tacctacatt aaattcatta aaatgtatgc
    13801 ctgggtcaaa gcgttttctc agtgtgtgca aagtgagttt aaagactttc cttgtgtacg
    13861 tggtgaaggg attttggatt ctttgggtct attcagtcat gtacgtcgct tcctaagcac
    13921 attagaaact agacttccaa tgtctacaat cttcatatag aatcgtttct aagcacatta
    13981 gaaactagac ttctgatgtc taaaatcttc atatagaatc gtttctaagc acattagaaa
    14041 ctagacttct gatgtctaca atcttcatat agaatcgttt ctaagcacat tagaaactag
    14101 acttccgatg tctacaatct tcatatagaa tcgtttctaa gcacattaga aactagactt
    14161 ccgatgtcta caatcttcat atagaatcgt ttctaagcac attagaaact agacttccga
    14221 tgtctacaat cttcatatag aatcgtttct atttaaaaga gctcagggat ttgagctcgg
    14281 gaactgattt tgccccaggt gttattgcta gctagaacgg tatggacaaa tctagctatt
    14341 agaatatatg caaatcctcc tcttacccag ggcatggttt ttggcagaag gcgctcagat
    14401 gattgccaag agcccatcta ttctgtgatt gtataggtac cagaggtggt tgtgtgaccc
    14461 ccgagggatg acctgggctt cacgatgcct cgactaagca cctccctctg ttacttgcta
    14521 ggggctcctt ttgtcatctt ttaaaacgat tgatataatt acagtgttct cagtgctggc
    14581 gctattcaca ttttaagttc agagcaggca taagcatgtg aagtattctc gcagcacaag
    14641 cctgtcaggg taactaacat gacactggca tttaaacact tctacacaag aataggaagg
    14701 ctgggcctta aaaacagtgg catttaagaa gagaagctaa aaaaaaaagg ataaccttaa
    14761 tttcagtaaa aagtatatat gggctgttaa tggacttaat gacatagtaa ctaccataaa
    14821 tgttgtaaac attaagacaa ttttaaatag aataaagagt tgtttgttag tatcagggca
    14881 actggtttgc tttctctgat taaactttcc ggaacttatc tggactctgc tcttataagg
    14941 tggttgaaca ccccagagta aataataagc actaaccata tacacaaaga aagctgccag
    15001 gtgtagatgc aaataaagtg ttctttttat tgaaacccag gagacagatg gaaggcgcat
    15061 aacgatacca cgatatcaac aagtttgtac aaaaaagcag gctggcgccg gaaccgaagt
    15121 tcctattccg aagttcctat tctctagaaa gtataggaac ttcgaaccct ttcccacacc
    15181 accctccaca cttgccccaa acactgccaa ctatgtagga ggaaggggtt gggactaaca
    15241 gaagaacccg ttgtggggaa gctgttggga gggtcacttt atgttcttgc ccaaggtcag
    15301 ttgggtggcc tgcttctgat gaggtggtcc caaggtctgg ggtagaaggt gagagggaca
    15361 ggccaccaag gtcagccccc cccccctatc ccataggagc caggtccctc tcctggacag
    15421 gaagactgaa ggggagatgc cagagactca gtgaagcctg gggtacccta ttggagtcct
    15481 tcaaggaaac aaacttggcc tcaccaggcc tcagccttgg ctcctcctgg gaactctact
    15541 gcccttggga tccccttgta gttgtgggtt acataggaag ggggacggga ttccccttga
    15601 ctggctagcc tactcttttc ttcagtcttc tccatctcct ctcacctgtc tctcgaccct
    15661 ttccctagga tagacttgga aaaagataag gggagaaaac aaatgcaaac gaggccagaa
    15721 agattttggc tgggcattcc ttccgctagc ttttattggg atcccctagt ttgtgatagg
    15781 ccttttagct acatctgcca atccatctca ttttcacaca cacacacacc actttccttc
    15841 tggtcagtgg gcacatgtcc agcctcaagt ttatatcacc acccccaatg cccaacactt
    15901 gtatggcctt gggcgggtca tccccccccc cacccccagt atctgcaacc tcaagctagc
    15961 ttgggtgcgt tggttgtgga taagtagcta gactccagca accagtaacc tctgcccttt
    16021 ctcctccatg acaaccaggt cccaggtccc gaaaaccaaa gaagaagaac cctaacaaag
    16081 aggacaagcg gcctcgcaca gccttcactg ctgagcagct ccagaggctc aaggctgagt
    16141 ttcagaccaa caggtacctg acagagcagc ggcgccagag tctggcacag gagctcggta
    16201 cccggaagat ctggactcta gagaattccg cccctctccc tccccccccc ctaacgttac
    16261 tggccgaagc cgcttggaat aaggccggtg tgcgtttgtc tatatgttat tttccaccat
    16321 attgccgtct tttggcaatg tgagggcccg gaaacctggc cctgtcttct tgacgagcat
    16381 tcctaggggt ctttcccctc tcgccaaagg aatgcaaggt ctgttgaatg tcgtgaagga
    16441 agcagttcct ctggaagctt cttgaagaca aacaacgtct gtagcgaccc tttgcaggca
    16501 gcggaacccc ccacctggcg acaggtgcct ctgcggccaa aagccacgtg tataagatac
    16561 acctgcaaag gcggcacaac cccagtgcca cgttgtgagt tggatagttg tggaaagagt
    16621 caaatggctc tcctcaagcg tattcaacaa ggggctgaag gatgcccaga aggtacccca
    16681 ttgtatggga tctgatctgg ggcctcggtg cacatgcttt acatgtgttt agtcgaggtt
    16741 aaaaaacgtc taggcccccc gaaccacggg gacgtggttt tcctttgaaa aacacgatga
    16801 taagcttgcc acaaccatgg aagatcccgt cgttttacaa cgtcgtgact gggaaaaccc
    16861 tggcgttacc caacttaatc gccttgcagc acatccccct ttcgccagct ggcgtaatag
    16921 cgaagaggcc cgcaccgatc gcccttccca acagttgcgc agcctgaatg gcgaatggcg
    16981 ctttgcctgg tttccggcac cagaagcggt gccggaaagc tggctggagt gcgatcttcc
    17041 tgaggccgat actgtcgtcg tcccctcaaa ctggcagatg cacggttacg atgcgcccat
    17101 ctacaccaac gtgacctatc ccattacggt caatccgccg tttgttccca cggagaatcc
    17161 gacgggttgt tactcgctca catttaatgt tgatgaaagc tggctacagg aaggccagac
    17221 gcgaattatt tttgatggcg ttaactcggc gtttcatctg tggtgcaacg ggcgctgggt
    17281 cggttacggc caggacagtc gtttgccgtc tgaatttgac ctgagcgcat ttttacgcgc
    17341 cggagaaaac cgcctcgcgg tgatggtgct gcgctggagt gacggcagtt atctggaaga
    17401 tcaggatatg tggcggatga gcggcatttt ccgtgacgtc tcgttgctgc ataaaccgac
    17461 tacacaaatc agcgatttcc atgttgccac tcgctttaat gatgatttca gccgcgctgt
    17521 actggaggct gaagttcaga tgtgcggcga gttgcgtgac tacctacggg taacagtttc
    17581 tttatggcag ggtgaaacgc aggtcgccag cggcaccgcg cctttcggcg gtgaaattat
    17641 cgatgagcgt ggtggttatg ccgatcgcgt cacactacgt ctgaacgtcg aaaacccgaa
    17701 actgtggagc gccgaaatcc cgaatctcta tcgtgcggtg gttgaactgc acaccgccga
    17761 cggcacgctg attgaagcag aagcctgcga tgtcggtttc cgcgaggtgc ggattgaaaa
    17821 tggtctgctg ctgctgaacg gcaagccgtt gctgattcga ggcgttaacc gtcacgagca
    17881 tcatcctctg catggtcagg tcatggatga gcagacgatg gtgcaggata tcctgctgat
    17941 gaagcagaac aactttaacg ccgtgcgctg ttcgcattat ccgaaccatc cgctgtggta
    18001 cacgctgtgc gaccgctacg gcctgtatgt ggtggatgaa gccaatattg aaacccacgg
    18061 catggtgcca atgaatcgtc tgaccgatga tccgcgctgg ctaccggcga tgagcgaacg
    18121 cgtaacgcga atggtgcagc gcgatcgtaa tcacccgagt gtgatcatct ggtcgctggg
    18181 gaatgaatca ggccacggcg ctaatcacga cgcgctgtat cgctggatca aatctgtcga
    18241 tccttcccgc ccggtgcagt atgaaggcgg cggagccgac accacggcca ccgatattat
    18301 ttgcccgatg tacgcgcgcg tggatgaaga ccagcccttc ccggctgtgc cgaaatggtc
    18361 catcaaaaaa tggctttcgc tacctggaga gacgcgcccg ctgatccttt gcgaatacgc
    18421 ccacgcgatg ggtaacagtc ttggcggttt cgctaaatac tggcaggcgt ttcgtcagta
    18481 tccccgttta cagggcggct tcgtctggga ctgggtggat cagtcgctga ttaaatatga
    18541 tgaaaacggc aacccgtggt cggcttacgg cggtgatttt ggcgatacgc cgaacgatcg
    18601 ccagttctgt atgaacggtc tggtctttgc cgaccgcacg ccgcatccag cgctgacgga
    18661 agcaaaacac cagcagcagt ttttccagtt ccgtttatcc gggcaaacca tcgaagtgac
    18721 cagcgaatac ctgttccgtc atagcgataa cgagctcctg cactggatgg tggcgctgga
    18781 tggtaagccg ctggcaagcg gtgaagtgcc tctggatgtc gctccacaag gtaaacagtt
    18841 gattgaactg cctgaactac cgcagccgga gagcgccggg caactctggc tcacagtacg
    18901 cgtagtgcaa ccgaacgcga ccgcatggtc agaagccggg cacatcagcg cctggcagca
    18961 gtggcgtctg gcggaaaacc tcagtgtgac gctccccgcc gcgtcccacg ccatcccgca
    19021 tctgaccacc agcgaaatgg atttttgcat cgagctgggt aataagcgtt ggcaatttaa
    19081 ccgccagtca ggctttcttt cacagatgtg gattggcgat aaaaaacaac tgctgacgcc
    19141 gctgcgcgat cagttcaccc gtgcaccgct ggataacgac attggcgtaa gtgaagcgac
    19201 ccgcattgac cctaacgcct gggtcgaacg ctggaaggcg gcgggccatt accaggccga
    19261 agcagcgttg ttgcagtgca cggcagatac acttgctgat gcggtgctga ttacgaccgc
    19321 tcacgcgtgg cagcatcagg ggaaaacctt atttatcagc cggaaaacct accggattga
    19381 tggtagtggt caaatggcga ttaccgttga tgttgaagtg gcgagcgata caccgcatcc
    19441 ggcgcggatt ggcctgaact gccagctggc gcaggtagca gagcgggtaa actggctcgg
    19501 attagggccg caagaaaact atcccgaccg ccttactgcc gcctgttttg accgctggga
    19561 tctgccattg tcagacatgt ataccccgta cgtcttcccg agcgaaaacg gtctgcgctg
    19621 cgggacgcgc gaattgaatt atggcccaca ccagtggcgc ggcgacttcc agttcaacat
    19681 cagccgctac agtcaacagc aactgatgga aaccagccat cgccatctgc tgcacgcgga
    19741 agaaggcaca tggctgaata tcgacggttt ccatatgggg attggtggcg acgactcctg
    19801 gagcccgtca gtatcggcgg aattccagct gagcgccggt cgctaccatt accagttggt
    19861 ctggtgtcaa aaataataat aaccgggcag gggggatcta agctctagat aagtaatgat
    19921 cataatcagc catatcacat ctgtagaggt tttacttgct ttaaaaaacc tcccacacct
    19981 ccccctgaac ctgaaacata aaatgaatgc aattgttgtt gttaacttgt ttattgcagc
    20041 ttataatggt tacaaataaa gcaatagcat cacaaatttc acaaataaag catttttttc
    20101 actgcattct agttgtggtt tgtccaaact catcaatgta tcttatcatg tctggatccg
    20161 gaataacttc gtatagcata cattatacga agttatgttt aaacggcgcg ccccggaatt
    20221 cgccttctgc aggagcgtac agaacccagg gccctggcac ccgtgcagac cctggcccac
    20281 cccacctggg cgctcagtgc ccaagagatg tccacaccta ggatgtcccg cggtgggtgg
    20341 ggggcccgag agacgggcag gccgggggca ggcctggcca tgcggggccg aaccgggcac
    20401 tgcccagcgt gggcgcgggg gccacggcgc gcgcccccag cccccgggcc cagcacccca
    20461 aggcggccaa cgccaaaact ctccctcctc ctcttcctca atctcgctct cgctcttttt
    20521 ttttttcgca aaaggagggg agagggggta aaaaaatgct gcactgtgcg gcgaagccgg
    20581 tgagtgagcg gcgcggggcc aatcagcgtg cgccgttccg aaagttgcct tttatggctc
    20641 gagcggccgc ggcggcgccc tataaaaccc agcggcgcga cgcgccacca ccgccgagac
    20701 cgcgtccgcc ccgcgagcac agagcctcgc ctttgccgat cctctagagt cgagatccgc
    20761 cgccaccatg attgaacaag atggattgca cgcaggttct ccggccgctt gggtggagag
    20821 gctattcggc tatgactggg cacaacagac aatcggctgc tctgatgccg ccgtgttccg
    20881 gctgtcagcg caggggcgcc cggttctttt tgtcaagacc gacctgtccg gtgccctgaa
    20941 tgaactgcag gacgaggcag cgcggctatc gtggctggcc acgacgggcg ttccttgcgc
    21001 agctgtgctc gacgttgtca ctgaagcggg aagggactgg ctgctattgg gcgaagtgcc
    21061 ggggcaggat ctcctgtcat ctcaccttgc tcctgccgag aaagtatcca tcatggctga
    21121 tgcaatgcgg cggctgcata cgcttgatcc ggctacctgc ccattcgacc accaagcgaa
    21181 acatcgcatc gagcgagcac gtactcggat ggaagccggt cttgtcgatc aggatgatct
    21241 ggacgaagag catcaggggc tcgcgccagc cgaactgttc gccaggctca aggcgcgcat
    21301 gcccgacggc gaggatctcg tcgtgaccca tggcgatgcc tgcttgccga atatcatggt
    21361 ggaaaatggc cgcttttctg gattcatcga ctgtggccgg ctgggtgtgg cggaccgcta
    21421 tcaggacata gcgttggcta cccgtgatat tgctgaagag cttggcggcg aatgggctga
    21481 ccgcttcctc gtgctttacg gtatcgccgc tcccgattcg cagcgcatcg ccttctatcg
    21541 ccttcttgac gagttcttct gagcgggact ctggggttcg aaatgaccga ccaagcgacg
    21601 cccaacctgc catcacgaga tttcgattcc accgccgcct tctatgaaag gttgggcttc
    21661 ggaatcgttt tccgggacgc cggctggatg atcctccagc gcggggatct catgctggag
    21721 ttcttcgccc accccccgga tctaagctct agataagtaa tgatcataat cagccatatc
    21781 acatctgtag aggttttact tgctttaaaa aacctcccac acctccccct gaacctgaaa
    21841 cataaaatga atgcaattgt tgttgttaac ttgtttattg cagcttataa tggttacaaa
    21901 taaagcaata gcatcacaaa tttcacaaat aaagcatttt tttcactgca ttctagttgt
    21961 ggtttgtcca aactcatcaa tgtatcttat catgtctgga tccgggggta ccgcgtcgag
    22021 aagttcctat tccgaagttc ctattctcta gaaagtatag gaacttcgtc gagataactt
    22081 cgtatagcat acattatacg aagttatgtc gagatatcta gacccagctt tcttgtacaa
    22141 agtggttgat atctctatag tcgcagtagg cggattgtag tgatggaatc gatagtccta
    22201 gggtgggggc tggacagtgc ttacccagca catgtgagtg acgccttagg tccagcctac
    22261 agaactgaca aaaccagagt tgatagtcca ttaaacggct ttctttttca tcattggtac
    22321 tgaaggatca tttaaaaacc tgcctgtatc ctaacatcat ggctcttggg aggctgaaga
    22381 aggaaagtct acactgcacg ataagcatag gctacatagc aagaacctgt cttaaacaat
    22441 caaacaaaac ccaaaataca aaagataaat ttgtagttgg aacctggttc ttgtttggtg
    22501 gtggagtaac agtttcccaa agtgtgtttt gacttgcttt gaggatgggt tgcttttcat
    22561 tagaaatccg agaggaggaa cgtcggatat tggagaaagc cgggtacttt cagagcatca
    22621 ctgttggagt ggctcctatt gtggtagtga tcgccagtgt ggtgacgttc tccgttcaca
    22681 tgaccctggg cttccatctg actgcggcac aggtgaggac agtcagacac gttctctgca
    22741 gagctgtgtg ctcctcttgt tacttcactt gggactgctt ccaagaatta ggtgtctcct
    22801 tcactcatat cactaagttg agaagtggaa gaatacggca ttatccctta tacaggaata
    22861 atgtggctta ttttcagtca gcctgggttt gggtttaatt ttgtaaatac agatgaacct
    22921 ttgtttcatg agatggcgca acgcaattaa tgataacttc gtatagcata cattatacga
    22981 agttatggtc tgagctcgcc atcagttcat atgaagaatg ttaggtgaaa gtctcattca
    23041 atacaaaccc tgcctttaaa atacaaatgt gagctgaagc ccagagtgaa acccagaggt
    23101 taagatattt attactcttg cagaggacta tgtagttcaa tttccagcac ccatagtggg
    23161 ctgcttggaa cccatgggta accccagttc caggagatct gacacctctg ggctgggctc
    23221 tgaggatacc acattcattt gcacgtactg tcagacacac acacacacac acacattctc
    23281 tctctctctc tctctctctc tctctctctc tctctctcat aatttaaaaa cgaaacttta
    23341 aactgtgatt gaggctgaca aggtggacag aggcacttgc caccatgcct aatgccctga
    23401 gcccagttat tggaacacac acggggaagg agagagccag ctcctttaag ttgtcctcag
    23461 acctccacac atgcactgcc atgcacacaa atgtactcgc ccacaagaca aattacttta
    23521 gtatgactgc gtgcactaac gtttgatagt tacagccttc cttccacccg aaaggagagt
    23581 ggtgccgcct tgtctactgt gtgacctctc gagaggcttg ctctcacctc ttttttgtat
    23641 tttaaggcct tcacagtggt gactgtcttc aattccatga cttttgcttt aaaagtaaca
    23701 ccattctcag tgaagtccct ctctgaagca tcagtggctg ttgacagatt taaggtaagt
    23761 ggtcccttgc ccgtatccgg agctatcctt ggtacagctt gcttgctgcc tgtattccga
    23821 gagtccacat aggccagctg cacttgcctt tggtttgcct ttaggagatg gaggagacaa
    23881 ctgaattaag ggatgagagt aatgcctttt aaaattaatg tgcatctttc tctctcccga
    23941 ttggctctgg gttgtgctcc ctttccacac tgagtactct gccaggccca gcatggatgt
    24001 gcattgtcat ttcctgagct tttaaagggc ttacgttaga ccagcacggc caggtgtctg
    24061 ccgggttctc cccaccccct ctcgtgcctg ctgccacttt gattggttgc tatgctgagt
    24121 ccttttgata tttctttttc ctacccagtg attgccacta catgaggcag ggaatgcagt
    24181 gacatggaaa tagtcataaa actagatcat gttgagaagt acagttaagt aagtatcggc
    24241 ccctttcctt gcgtggttag ttgatcagac ccttttgtgt tctttgtacc ttcagaataa
    24301 cacaaccgtg tgacacaaga gggagtgacg tgggtgggtg gaggggagta gatacttact
    24361 tggaagtggt taatgcttaa ttcctacaaa ggagaggcac tgtgtgtgct ggagttcatc
    24421 aacaagacct cacctcactc ctcgtggcct tccttggcca gcgaggtgaa caagggaaca
    24481 gttctggtgg cctgaagagt tgaagcccca ggactagaag gatgactctc actaccttag
    24541 aggctcaggg gccacagtgg gctgccctgt aaaggagaga ttagttgctg ggatttacct
    24601 cagcctttgc cttttacagt tagtcaggtg acttgcattg ggccaagaga agtagtcttc
    24661 cagaacatcc ccctttctcg tgctttcctc cttctcctgg ctgctaaagg accagagcca
    24721 gggtcacatg agactgatgt ctgagagaca gtcagagctt tgtctctcag aagccaccga
    24781 acccagtcat ggaagaaagt gaaagttctg accaaagcgc tccctgtttt gttgagtttt
    24841 agatgaagaa ctaagggaga aaaagttctg tgaccttgct tttgaattgt ctccttttaa
    24901 gtgagtacag tgttagctgg tagtataggc atatttatac tggaaaaaag atctataatt
    24961 tttttaattg gaatcctagt gtaactgcgt tgtgttatat ctggcagccc tctgagcact
    25021 ccctcttcta atgagtgaaa gcaagctgtt tttcctcttt ggattgttgg aggtgtttgt
    25081 ttttgagaca gactggctgc taacacacag ttatcctgcc ttggcctcct tggtgctgag
    25141 gttactgcta tacacctcac cgaggggcta ggaagcgctg tcagcgggca gcctcctaga
    25201 ggaaggtgag gtttgtgcgt cctggcaggt gcacatctca gtcggtgcac attcaggtgt
    25261 tgtccgtcaa agcgtgtcag ggctgtggga agcagaaagg aagagcaggg agactgcgtt
    25321 ctccgatagg caccactgtt tctctgaata gtctataggg gcctacacag tctcttttta
    25381 acagatcttt ggggaaggaa atgatcagaa tcattgacga tattatagcc tagtctctca
    25441 gaaggctctg gatatacaaa tcccatagct gctcatagac aggagcttta cttaagcctt
    25501 acgacccccg gggtgtacag gaatagcaac tgtgatccca gctcttgtag gtggcaacag
    25561 gagggtcagg gctcgcggtc attcttgggt gcccagggct acatgagatc ctttatttta
    25621 tcttttagga ttgatttatt tattttaatt tttcttttac ttttgaaatt ataattacat
    25681 aatttcctcc atcccttccc tttctttaaa ttctcacaca tacccttcct tgctctcttt
    25741 caaacttacg gcctcttttt ctcactaatt gtttttctat acatatatgt atatctgtat
    25801 gtatgtgtat gcatatatat gttcctaaat acataaatac aacctgctca gtctgtataa
    25861 tgttactcat gtgtatgttt cagagctgat catttgacat agataaccag tggaggaggg
    25921 gagggctctt tcctggggaa gacgatggct cttgctctta gcattcctta gttgctgtag
    25981 ggtcatgagg gcctcgcggg ctcccccagc ctgacccatg ctagcatgtc tgttgttgtc
    26041 cttgttcagt tcagtaagat gctttcttaa tcttcttaaa agcacgctgg gatccaggag
    26101 aagggggaga ttacctgttc cattcattag tacttgggaa ctttaagcca tttggggtat
    26161 ttcgtaattg agtagagtcc tcatcctgca agccatcttt tctctaaaga ttttctaatg
    26221 ttttaaatta atttttaaaa agcattttga aaatcacctt gcaatagtgc tctgtaaaaa
    26281 tttcctggct tgtgaggggt tcgagtataa ctagaaaatc agaattttag aagtaacttt
    26341 ggagactctt ccccatttca cattacattt tcctgctctt tgaaacaact ctgtaggact
    26401 ctgtaaataa gtggagagaa aactaactct tttcccctgg agcgattctt ggggaggtac
    26461 ctcttgtcca cacgggccct tagctcagat gttttccaaa tcctgcaatt aagaggtgcc
    26521 aggccatggg tgagggcagt gtgcaggcat tagctctaca gaagtgtcct ggaaggtccc
    26581 tggcatcgtg atgcctgtgt aaagggtcag tatccctcct gggatttcta accattactc
    26641 tggaacctat gaatttctgt acgtggggca ccatatccct atgagttctt aaatgtcctt
    26701 ctgtccatat tagactggca ggaaaagcag ggtgccttag tgtgtaagct agcatagagg
    26761 gttgggtcag tggacgagcg aggccctgag accccttgcc agtcctgagg tgaggctaca
    26821 ctaatgagct accttttgct cttcagcttc cttccactgt atagcctgat gtgttttgct
    26881 acgtgagtgt acgccataag cttgtctccc tggtcttgat ccagtgtctc atctttgcac
    26941 ctctctcaca actcctatca gagtttgttt ctaatggaag aggttcacat gataaagaac
    27001 aaaccggcca gtcctcacat caagatagag atgaaaaatg ccaccttggc atgggactcc
    27061 tcccactcca gtatacagaa ctcgcccaag ctgaccccca aaatgaaaaa agacaagagg
    27121 gctaccaggg gcaagaaaga gaagtcgagg cagctgcaac acactgagca ccaggcggtg
    27181 ctggcagaac agaaaggaca cctcctcctg gacagtgacg agcggcccag cccggaagag
    27241 gaagaaggca agcagatcca cacagggagc ctgcgcctgc agaggacact gtacaacatt
    27301 gacttagaaa ttgaagaggt aagctaccta cccgtaccct ctctgccact tcagccctga
    27361 ctcctgtgtc accccagctt gaccctggca agacccgccc tttaagcaga gtattttgac
    27421 tatgagcagt tttgaatcaa gagcagattg gactctgatt ccaaagcgag caacagaact
    27481 aattacttat gagatgcttg ctttactgat aaggaggtga agcactcagg tggaccttcc
    27541 aagaccctgc tctgggttgg cttctggctg tgatggctgt tgtaattaaa ttcactgctg
    27601 taactgtgtg ggctcctggt caacatcacg ttgtgcagca tagagaactt ggcatataaa
    27661 aggtattctc aatgctgcct tttctttttc cttttaaatt tatttgacat atctgtttgt
    27721 aggtgtgtgc acgtgagtgc aggagccagt ggagggcaga agacagtgtc agattctctg
    27781 gagctggagt tacaagtggt tctgagctgc ctggttgacg tagggtcctt tgaaaaagca
    27841 tcaagtgctc ttaagccact aagccatctc tccagcctct cagggctgct cttagcaact
    27901 gtattgtaat aatttttaaa aatataagtg aagggtgatt tgggtataga atatcatagc
    27961 tcagctagca tagacatggg ctctcagaga gtcccttaaa acacagattt taggtcgaag
    28021 atttaagatt caaactatga ctgagaagta gccccattca cactttcctt cagtagcctt
    28081 tggttttttt tttaagtacc agctttacac caagtcctgt tgaaggactg agaacaaaca
    28141 acagcagaac ctacacagtc aaagcctctt tctggagttt acgtccctag tggacagaca
    28201 caaagcaagt gtcaggttgt ggtaagggac gatgcaaagg atggtaacgg agctgggaca
    28261 gcagctgttg tgcttgcatt tttaacacat tttctaagga gaagacccca ttcaaaggat
    28321 gttttagtca ggcttggcag gacatgtccg tagtttgggg caggctgtgg tagatcacta
    28381 tgaatttgaa gccaacctgg atacatagtg ataccctagc taagaaggtg gtggggatgg
    28441 gcatggcagg taaacccagt aagtaccagt gagagagggg aggagagaga ggagagagag
    28501 ggtagtgttt gagcggagaa ctgagagagt gagtcgtgag actgtctagg ggagagggtc
    28561 atagctaaag agcagaagca gagagcaagg ctctccgtct ggagtgtgct ggttcctgga
    28621 ccaggatgag tgtgggagat gatggccgat ggcagatttg cagaagtgcc tgtggataca
    28681 taatgtcctg ctaggctcag aagggtgtgt ggagaaacaa ggaaggaaag aaggagaggt
    28741 ctaaggggct gctcctcctg ctgcagtgca ggaggaagac gggagagtga tggagacagg
    28801 gctgggtaga aatgctgcag agctagaagg aggcactgct gcagcaagtg gccatactga
    28861 ccgctgcctg gggcaccgtg ggcagatcca gaggtagacc caggagacag catccagatt
    28921 tctgctctta gcaggcggtc gggggtggtc accggaaact gtcatgtagt ttatcccaca
    28981 taggccaatc ttagcagcag tttgcttact tgatgacgat tactgatttc tgaggtggtc
    29041 ccaccgtgtc actaatcagc tcttttagat actggctttg catactcaac ggaaagttac
    29101 tcttccattt ggtaatgtga tacttgattc agtgaggaac tcacccttcc tcctgagctc
    29161 agagcccagt gagggaaaca gacacagggt tggcttggga tatctatcgg gacacatgat
    29221 tagcagatgt ggtagagctg aaactctggt gcgaactgcc tgcctgcagt ctgggatcac
    29281 ttctgcacca ctgctctagc ctccctcctt ctcttgggga cttgattacc atcacacaga
    29341 actgccacac acgtggctct ccttaaagtt aactgttggc cagaacaatg gctcagtagt
    29401 aaagagcact ggctgctctt ccagaggacc tggattcaga gcatccgcac ccacaggcgg
    29461 ctcacagcca agctccagtt ccagcggttc tgacaccttc tcctggcctt tgcaggcacc
    29521 aggcacacaa gtgatatgca ggcatacatg aaggcaaaac acccacactt atattaggca
    29581 ggtggatctc tgagttcgag gccagcctgt tctacacggt gagttctagg acagcctagg
    29641 ctacacagag aaaccctgtt ttgaaaaacc aaacaagccg ggcggttgta gcgcatgcct
    29701 ttaattccag cacttgggag gtagaggcag gcggatttct gagtttgagg ccagcctggt
    29761 ctacaaagtg agttccagga cagccaggga tatacggaga aaccctgtct ccaaaaaaac
    29821 aaaaaagaaa aaccaaccaa acaaaataat aataaataaa acaataaata aagccaggtg
    29881 tggtggcgca cgcctttaat cccagcactc gggaggcaga ggcaggtgga tttctgagtt
    29941 caaggccagc ctggtctaca gagtgagttc taggacagcc aggactacac agagaaaccc
    30001 tgtctcgaaa aaccaaaata aataaataaa taaataaata aaaatgatat tttaatgtat
    30061 ataatactac atgtagttcc tactaaaaga aaataaaaat tacaattaag taattttaaa
    30121 gagttctgcc ttgcaaaaat acaattaaaa aataaaagct tatactgctt gcagagttgg
    30181 taagaggcta agacttccta aaagtgattg tgtgtgacag tctttccaga gggcttccgt
    30241 gtccctgtac tgatggacca actgcaggtt cttaggatga gtggctggta gtctcttgat
    30301 gtcgttcctc tctctgtgct tcgtctaggg caaactggtt ggaatctgcg gcagtgtggg
    30361 aagtggaaaa acctctctcg tttcagccat tttaggccag gtaagacgtt tgttatgccc
    30421 ttggtatttt ctggtccttt attaggcttg gcttagcaaa catttcagga acgataagct
    30481 cagttgctga agagtcagta gaggcgtgtt ggtcctcgtc caccccgctg ctggccacag
    30541 tctcttgggc caccaccagg ccagtgccgg gctgtaggga agctccaaga cacctcttca
    30601 ggggtgggaa atgcagtctg agatgtggga aagtcagagc tggttcaggg ctccctgggc
    30661 ctgtgacgag gctgggatca tggggttctc agactctggg acatttaggc accactggga
    30721 gtcaaggaag agccaagaat ggggttgggg gatgggggtg ttgggctagg aacagcatct
    30781 agcctggggc tgggggcaag gggagctctg gcttgtccca gcggtgattg tccttagctt
    30841 ggcagaggca ggcttggtgg cagttgtggc tgggagcaca gagaggcctt ctacaggaga
    30901 attaagctgt ggttccatag gcaaacgcct tctccatgct ccccacagcg gatcttgatg
    30961 aaagagacag tctgtggttc taaacagttt attggctgtt catggtggaa aatggatgca
    31021 tactgtatca tactcacttc tcagggtggg cctgagatca aatacctttt acagagagga
    31081 atgtctggga agggaagctt atgggcaaag ccctctgggc ctctaggtac ctcattagca
    31141 tggagaactc tgttttgggc ctatgtcacc acaggacata cttcttttat gtaaggagca
    31201 tggcacatgt tctaggcagg gagtggggag ttgcctcaat ctcaggtgtg tacctaccga
    31261 gtctctgggc ctctgcacgc tctatcttac caacaaaggt ggaaacaaag ggactgtgat
    31321 cagcgcttca tttctccatc ttaacagcct tctgtctgga atggtgcagt gaatgcctgg
    31381 tgactggcta atagacgcac accgccacca tttgttccct gtgcctcttc tcattcagga
    31441 agtagggaag tagttactgg atgtgtgtgg caggtgtgct aagaaaggaa gcagcaggga
    31501 tgagagggat gatccaacac cccacactgt agattctgac gcgtactctc gcttgatctt
    31561 cagcctaaac cctgagactg ttacttcttc agggagttca tgtccagaag agactcagtg
    31621 atctagatac acaagtgtat catgaaacag caagagaaaa gtgtagcact gtgagagagt
    31681 gaggggaaag agtaagcaca gattccttga gtgtgtagaa cccagtcatc agaaaagagt
    31741 aggtgccagc atacaagatt tcaaacacct tgactttgat gcagatgaag atgggcatgc
    31801 agttggcgcc acttcttgcc aggtgccgcc ttctgaactg ttggggacag tgggacctgt
    31861 gttttgaaga cagtttcctt gtcctgtttg gtaccagcca ttgtagtgta ctgtagtcct
    31921 cctagagcac aggactgcgt tctgctttat gctatgctat ggtccgtggg cccagctctg
    31981 ggtctgtaaa aagcaagagc ctaacaggtg gtttctcata atcagccaga tttgagggcc
    32041 agttatgaag ctggggctct tgggagtatg aaggtcatct ttcacagcac ttctgaacat
    32101 ttgccaggtg ctgcttttca gggggtgtct aggctgtggc taagcttaaa ccaagtgggt
    32161 tttggctttc gtggatccaa tcctggcagc cagacaggga ggctggtagt gcaggtcagt
    32221 tgtcctttct ttagagttta actctccgct gacagtgttg ctgtgagcag ctaggaatgt
    32281 agctttctga tttgcacagc aaattgattg ccagtttgta ggaaaatgtc cctgcacaca
    32341 cagtgtgtga tggtgttcgt aagggcgggc ttatttgtca cgcattccat gcgttcatta
    32401 atgaaacttt gcttcatagc gtgatcatcc ttaactcaaa cagggtctac tgttggtctc
    32461 aataagaatc atgatacaag tggtgcatca gttggtatca agcctgatag aagacacatc
    32521 agggggctgc agagatggct tagctcagca ctgactgctc tttcagggga accacattga
    32581 attcccagca cccacatgac agctcacaac tatctgtacc tccaagattt gacagtctca
    32641 cagacataca ttgatgcaaa aacaccaagg catataaatt aaaaataagt aaatgatttt
    32701 taaaaaaaag aaaaaacaaa caaaaaagct tttggcctga agagatggct cagcagttaa
    32761 gagcactaac tgctctcttc cagaagtcct gagttcagtt cccagcaacc acatggtggt
    32821 tcacagccat ctgtaatagg acctgatgcc ctcttctggt gtgtctgaag acagtaacca
    32881 tatgctttca tacataaaat aattttaaaa acagaaaaag aaaagaaaac acatcaaagc
    32941 tatggctctg catgcagcct cttgatgttg gtgggaagct ctctaggctt attattatta
    33001 ttattattat tattattatt attattatta ttattattat ttggatgctc ttcacatcag
    33061 ttgatataac ctgaagttct gtttcctctc tgctcctcac ttcacagaag cagctgatct
    33121 agtcaatatc ctggatgaat cctatagata acttggccac cctcgccttg aggcaggttc
    33181 tggctacaaa tttttatggc accctctcca gggaactttg aaaagaggcc ttcttgcttg
    33241 ttgtattgtt agttagggtt ctctagagga acagaactga tagaatgaat gcttatatat
    33301 atttattcac aatatatgaa ttacataaca aacataatat atgaatatat gtacacatgt
    33361 gtttatgtta catgatgtat atacatacaa acaaacaaac aaataataaa atatgtataa
    33421 agggattttt gtttgtttgt ttgtttgttt gttttgtttt gttttttttg agacaggatt
    33481 tctctgtata gccctggctg tcctggaact cactttgtag accaggctgg cctcgaactc
    33541 agaaatctgc ctgcctctgc ctccccagtg ctgggattaa aggtgttcac caccaccacc
    33601 tggctgtata aagggatttt tgaatggctt acagactctg ttcattttgg ctagtccaac
    33661 aatgtctgtg tcctaatagg attgtcaaga gtccagcagt tatccagtcc accaggctgg
    33721 atgtctcagt gattagcaaa ataatgcttc agcaggagga taaattaact tgccaactaa
    33781 cgtgagggta agcatggaaa aagtaagact gtccttctgc catgtccttt tacttgggct
    33841 agcaccagaa agtctgccca gatctcagtg atccagatgt agagtgggtc tcctgccctc
    33901 caatggtcta ggtttagagt aagtctttcc acctcaaatg atccagtcaa gaaaaccccc
    33961 agcaagtgtg ccaggtgctt gggtttcagt taattccaga tgtagcaagc tgacaaccaa
    34021 gatcacccat tgcaagctca cttcttctca ccttggcaca tacttacatc ttacgtcatg
    34081 cttactttcc acagaaaaac aataactagg ttgtaatttt tcataacatg atataactat
    34141 cccatgtaca acctcaaact acatatttta tagtaggtga tatctttgag gaatcttggt
    34201 cttttactgt cttataacaa atgtggtaac tcttcatact aactcaatgt tacattacat
    34261 gatgaagaaa taaagaacac aaatatcatt taatatagat atatactgca caaatacatt
    34321 ctttttttaa taaagattta tttatttatt tatttattat atgtatatta tatgagtaca
    34381 ctgtcatctt caggcacatc agaaaagggc attggatccc attacagatg gttgtgagcc
    34441 accgtgtggt tgctggaaat tgaactcagt acctctggaa gagcagccag tgctcttaac
    34501 tgctgagcca tctctccagc ccacacaaat atgttctttg tgtgtgtgta tataatatta
    34561 tatatatatc atatattata tatatcatat aatatagatt atatcatatt atatatatat
    34621 catataataa agatcatatc atatatatct tccatttaat aatgaatggc tgctctgcac
    34681 atcctactca tgacttgttg ggtcagatac tacccagttc ctgattgaca gctcagttgc
    34741 atgataatgt catggtccat tgtcaaatgt tcattttcta ctaaggttcc atagcaggcc
    34801 aatagcagtc tctccaaggg agaacagttg tctatgaata atggtagagc tttgctccaa
    34861 aataccaaga ggctcttttg tgattctttt acaatggcag agcatctctg tctgccactg
    34921 acacctcaag tactatcagg tctgctggct catatggccc cagtagtaga gcaacctgca
    34981 tggcagcctg gacctgctga agaaccttct cctgtcccag gccccactca ggtaacagct
    35041 tcctgggtca cttgttatat gggcctgagt aacacaccca agtgaggaat gtgctgcctc
    35101 cagagtccaa ataggcccac tgttgctttt ctgttgctat gaagagacac catgaccaag
    35161 gtagcttata gaggaaacag tttactgggc cttacagttt ccatgaccat catggcagga
    35221 gcacagccca ggtaagcagg catggtggta gagcagaagc tgagagctct atgtcctgat
    35281 ccacaaacta aagacagaga gagttaattg ggaatcttgt aggcttttga aaccccagaa
    35341 cctgcctcca gtaacatacc acctccaaca agtccacact ttctaattct tcccatgtag
    35401 ttccattgac tggggaccaa gtattcaaac atgtgaccct ggggtgggag gcattctcat
    35461 tcagaacacc acacccactg aggattgtcc ttctttcatg gtggtgggag gagccaagtg
    35521 caataactta tccatcacct agggaagaat atctctgcat ttgtgttacc aacaagttca
    35581 aggtgttttc tcctcctgct cacttggtac aatcagcata atgtcatcag tatagtgggc
    35641 caatgtgata tttgtagaag agacagataa tcaatatccc ttcaaactaa gttatgaaac
    35701 taggctggag agttaatata tccttaaggt aaaactgaag gtatgttgtt ggctttgcca
    35761 actaaaagca aattgctctg gtagtcctta tggacagtac agagaaaagg gcatttgctg
    35821 gatcagtagt tgcataccaa gtagcaggag atgtctggtc aagcaaagac acagctggta
    35881 cagcagcagc agagtcacag tcactctccg taatccagct gtcttttgca tagaccaggt
    35941 cagagcattg aaaggagact gggaacctgc gccgttcatg ttctacagtg gcactcgttt
    36001 ctgtcatttc ttcagggata cagtattggt tttagttctc tgttatccct ggtagaggtg
    36061 actccaatac attccatttg gcctttccaa ccaaaatagc tctcactcca caggtcttgg
    36121 aaaaatggga ttctgccagc ttttaattgt atctatccca attatgcatt ctgacactga
    36181 gaaataacta cagatgagtt tagggatcca caagctctac ggggactcca tcagtccctg
    36241 acctccaaag acccacgtta actagatgtt cacaatgctt cttgtggtct ttcaggatca
    36301 gtttcactca gaacaggtat cgaatacctg gaaagtctat gattatttcc tttaacccct
    36361 gtgtattgtt tgctttgtaa aaagccatag atcttctgag gaaggtggga gaaagactaa
    36421 cagtaaaacg tttagatatt ttcttcaggt cattcttcca ggggatctag cagttcttca
    36481 ttcacagggt tctgggcctg caaactgact caagtctgga gattagttcc tggaccgaga
    36541 tttcctattc tcccatccaa tggaggcttt ctttgtttga aaattttcct gcttatacag
    36601 atgaaacaaa aacatagatt tattatctac cgtgggactt tctggacccg ccagcaccat
    36661 taatttttat tattgcttag gccttagctt aggccacctc tcagctggct cctctaattt
    36721 aaccttatcc tagctcacta cccaccatat ggttctttac ttctctcggt cttggtaagt
    36781 cagaacacct ctgtgtctca ctggcaaatt cttcctgcct ctgcttcttt tcccagagac
    36841 cttggaagct tggaagtcct gcctagctac tggccattgt gtccattaac tctttattaa
    36901 gcgagtcatc cgtgaggtag ctttgtgttt acaaaatact gacacaggtg atgagccata
    36961 agaataacaa tatcagtgtc tggccagcac tcagctctct gctggcacag caatcaacaa
    37021 ttgaataata caaaggcaac cttcacacgg tgtacaaaaa gcttacccca acatttatca
    37081 attatcatgg taacttaagg tccctgtgaa ttatcgcaca ctaaacgtcc cctttccctg
    37141 tgctgcccgt cacaggttag gctatgatgc acgtcatttt ccttttggtg agtctatgtt
    37201 gccaggtggc ctctgttact cctggcccaa taagcccgtt gtattaacgt catccaattg
    37261 aactgtagca tctccattct gtcacaaaga aatcagtgtt gacaaaggcc ttcagatgtg
    37321 cgggtgtctc ctcacccctc aaattggggt gcagagagcc cactgaagtg gatgcctcca
    37381 tgggtggaaa gaaaggcttt ggggagatca aactgccaag gctatcttgg gtgaggagga
    37441 gagggcagaa agaagagcaa aaatgtcaga aaagcagatt ttatatgatg gtcagcagag
    37501 tgggaggctt tgagctgata taggctgttc agaatgacct gactggtaac cagatgccct
    37561 tccctgaggt agttgacctt tgagaacaga ttaaggaagt ttcctcagag tttaagagaa
    37621 gttgctctgt ttatccaata acagtcctgt tttggacgtt gtcaccagca ctgccttttg
    37681 aggggcactt tgaagggtgt gggggattgg gttttacacg gcctatccag tctagtgttg
    37741 caatttccca agccgtcaaa tcccttcatc aacactaaat gaagggatat cagatatttc
    37801 tagctcttct tcagcaggcc atctttttaa ttaattattt tatttattta cattccattc
    37861 attgctccca tcccagctct cccccacagt ttctcatccc atcccccctc ccccttgcct
    37921 cagagagggt gctccccctt cccctcccct tccctgggcc tcaagtctca aggattgggt
    37981 gtatccctgc tgaggccaga ccaagcagtc ctctgttata tatatgtgga aggtgggagg
    38041 ggtgggcttg gatcagccc
//
GENBANK_DATA
      @image = AlleleImage::Image.new( @input )
    end

    should "instantiate" do
      assert_not_nil @image
      assert_instance_of AlleleImage::Image, @image
    end

    should "have the correct default parser and renderer" do
      assert_not_nil @image.parser
      assert_not_nil @image.renderer
      assert_instance_of AlleleImage::Parser, @image.parser
      assert_instance_of AlleleImage::Renderer, @image.renderer
    end
  
    should "render something" do
      assert_not_nil @image.render()
    end
  end
end
