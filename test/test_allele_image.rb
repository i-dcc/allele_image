require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImage < Test::Unit::TestCase
  context "a new AlleleImage::Image" do
    setup do
      @file = File.dirname(__FILE__) + "/../misc/project_47462_conditional_allele.gbk"
      @allele_image = AlleleImage::Image.new( @file )
    end

    should "instantiate" do
      assert_not_nil @allele_image
    end

    # should "return the correct number of features" do
    #   assert_equal 30, @allele_image.features.count
    # end
    # 
    # should "return the correct number of rcmb_primers" do
    #   assert_equal 6, @allele_image.rcmb_primers.count
    # end
    # 
    # should "return the correct number of cassette features" do
    #   # check what the correct number for this file should be and adjust
    #   assert_equal 11, @allele_image.cassette_features.count
    # end
    # 
    # should "return the correct number of 5' arm features" do
    #   assert_equal 6, @allele_image.five_homology_features.count
    # end
    # 
    # should "return the correct number of 3' arm features" do
    #   assert_equal 9, @allele_image.three_homology_features.count
    # end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @allele_image.write_to_file( File.dirname(__FILE__) + "/../misc/allele_image.png" )
    end
  end

  context "a non conditional allele" do
    setup do
      @allele_image = AlleleImage::Image.new( File.dirname( __FILE__ ) + "/../misc/project_47462_non_conditional_allele.gbk" )
    end

    should "instantiate" do
      assert_not_nil @allele_image
    end

    should "render" do
      assert_not_nil @allele_image.render()
    end

    should "write to PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @allele_image.write_to_file( File.dirname( __FILE__ ) + "/../misc/project_47462_non_conditional_allele.png" )
    end
  end

  context "a new AlleleImage from a string" do
    setup do
      @from_string = AlleleImage::Image.new( <<'EOF'
LOCUS       allele_44372_OTTMUSE00000345825_L1L2_Bact_P        38059 bp    dna     linear   UNK 
ACCESSION   unknown
DBSOURCE    accession design_id=44372
COMMENT     cassette : L1L2_Bact_P
COMMENT     design_id : 44372
FEATURES             Location/Qualifiers
     rcmb_primer     complement(10450..10499)
                     /label=G5
                     /type="G5"
                     /note="G5"
     rcmb_primer     15002..15051
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
     genomic         10450..15051
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
     rcmb_primer     complement(22174..22223)
                     /label=U3
                     /type="U3"
                     /note="U3"
     rcmb_primer     22880..22929
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
     genomic         22174..22929
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
     rcmb_primer     complement(23010..23059)
                     /label=D3
                     /type="D3"
                     /note="D3"
     rcmb_primer     28074..28123
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
     genomic         23010..28123
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
EOF
)
    end

    should "instantiate" do
      assert_not_nil @from_string
    end

    should "write to PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @from_string.write_to_file( File.dirname( __FILE__ ) + "/../misc/project_47462_from_string.png" )
    end
  end

  context "a new AlleleImage from NorCoMM file" do
    setup do
      @nor_comm = AlleleImage::Image.new( File.dirname( __FILE__ ) + "/../misc/NorCoMM_example.gbk" )
    end

    should "instantiate" do
      assert_not_nil @nor_comm
    end

    should "render" do
      assert_not_nil @nor_comm.render()
    end

    should "write to PNG returning a Magick::Image" do
      assert_instance_of Magick::Image, @nor_comm.write_to_file( File.dirname( __FILE__ ) + "/../misc/NorCoMM_example.png" )
    end
  end

  context "a new AlleleImage from NorCoMM string" do
    setup do
      @nor_comm_from_string = AlleleImage::Image.new(<<'NOR_COMM_FROM_STRING')
LOCUS       allele_82917_OTTMUSE00000464297_B1B2_frame0_Norcomm        37323 bp    dna     linear   UNK 
ACCESSION   unknown
DBSOURCE    accession design_id=82917
COMMENT     ApEinfo:methylated:1
COMMENT     cassette : B1B2_frame0_Norcomm
COMMENT     design_id : 82917
FEATURES             Location/Qualifiers
     rcmb_primer     complement(12904..12953)
                     /label=G5
                     /type="G5"
                     /note="G5"
     rcmb_primer     15002..15051
                     /label=U5
                     /type="U5"
                     /note="U5"
     exon            12176..12364
                     /db_xref="ens:ENSMUSE00000145253"
                     /label=ENSMUSE00000145253
                     /note="ENSMUSE00000145253"
     LRPCR_primer    complement(1..28)
                     /type="EX32"
                     /label=EX32
                     /note="EX32"
     LRPCR_primer    12442..12469
                     /type="GF4"
                     /label=GF4
                     /note="GF4"
     LRPCR_primer    complement(1..28)
                     /type="EX52"
                     /label=EX52
                     /note="EX52"
     LRPCR_primer    12435..12458
                     /type="GF3"
                     /label=GF3
                     /note="GF3"
     genomic         12904..15051
                     /label=5 arm
                     /note="5 arm"
     misc_feature    15225..15507
                     /ApEinfo_fwdcolor="#ffff66"
                     /ApEinfo_revcolor="green"
                     /label=UiPCR
     misc_signal     19596..19649
                     /ApEinfo_fwdcolor="#ccff66"
                     /ApEinfo_revcolor="green"
                     /label=T2A cleavage site #2
     misc_feature    16464..16517
                     /ApEinfo_fwdcolor="#ccff66"
                     /ApEinfo_revcolor="green"
                     /label=T2A cleavage site #1
     polyA_site      20633..20882
                     /ApEinfo_fwdcolor="#76ff5b"
                     /ApEinfo_revcolor="green"
                     /label=SV40 polyA
     misc_feature    16422..16455
                     /ApEinfo_fwdcolor="#66ff66"
                     /ApEinfo_revcolor="green"
                     /label=SA exon (En2)
     misc_feature    15552..16421
                     /ApEinfo_fwdcolor="#66ff66"
                     /ApEinfo_revcolor="green"
                     /label=SA (En2)
     polyA_site      21656..22111
                     /ApEinfo_fwdcolor="#fff20e"
                     /ApEinfo_revcolor="#fff90e"
                     /label=PGK polyA
     gene            join(20979..21029,21031..21091,21093..21578)
                     /ApEinfo_fwdcolor="#8b8bff"
                     /ApEinfo_revcolor="#1545ff"
                     /label=Puro
     gene            19650..20632
                     /ApEinfo_fwdcolor="#ffc6ee"
                     /ApEinfo_revcolor="green"
                     /label=Neo
     misc_feature    16518..19595
                     /ApEinfo_fwdcolor="cyan"
                     /ApEinfo_revcolor="green"
                     /label=lacZ
     misc_feature    22148..22181
                     /ApEinfo_fwdcolor="#e7afff"
                     /ApEinfo_revcolor="#45fcff"
                     /label=FRT reverse
     misc_feature    15191..15224
                     /ApEinfo_fwdcolor="#f3ccff"
                     /ApEinfo_revcolor="green"
                     /label=F3
     misc_feature    complement(20916..20964)
                     /ApEinfo_fwdcolor="#e108f5"
                     /ApEinfo_revcolor="#dd07ff"
                     /label=AttP
     misc_feature    22224..22274
                     /ApEinfo_fwdcolor="#586aff"
                     /ApEinfo_revcolor="green"
                     /label=attB2
     misc_feature    15052..15103
                     /ApEinfo_fwdcolor="#6666ff"
                     /ApEinfo_revcolor="green"
                     /label=attB1
     misc_feature    15508..15549
                     /ApEinfo_fwdcolor="#ff6967"
                     /ApEinfo_revcolor="green"
                     /label=Restriction sites for UiPCR
     misc_feature    16456..16463
                     /ApEinfo_fwdcolor="#3337ff"
                     /ApEinfo_revcolor="green"
                     /label=Frame 0 insert
     rcmb_primer     complement(22275..22324)
                     /label=D3
                     /type="D3"
                     /note="D3"
     rcmb_primer     29442..29491
                     /label=G3
                     /type="G3"
                     /note="G3"
     exon            26766..26886
                     /db_xref="ens:ENSMUSE00000481238"
                     /label=ENSMUSE00000481238
                     /note="ENSMUSE00000481238"
     exon            31834..31931
                     /db_xref="ens:ENSMUSE00000145251"
                     /label=ENSMUSE00000145251
                     /note="ENSMUSE00000145251"
     exon            37180..37323
                     /db_xref="ens:ENSMUSE00000472082"
                     /label=ENSMUSE00000472082
                     /note="ENSMUSE00000472082"
     LRPCR_primer    complement(31033..31058)
                     /type="GR4"
                     /label=GR4
                     /note="GR4"
     LRPCR_primer    complement(31028..31053)
                     /type="GR3"
                     /label=GR3
                     /note="GR3"
     genomic         22275..29491
                     /label=3 arm
                     /note="3 arm"
BASE COUNT     9567 a   8904 c   9350 g   9502 t
ORIGIN      
        1 acgcccattg tcaaggtcac tctcctgcac ttaaagtcat tttttttccc tctagccaca
       61 catacaaaat tctttgacat tcacagcctc ttcttggagt aaacatgcgc agggccttct
      121 gacctgctgc aattctggct agttggtttc tgggctttct ccacctttgg catcttggga
      181 cctctgaaca ccagcaccct gggaacttcc ttcatctcca tcttcagtca gagggtcaga
      241 ggtgacatgg ctccaaggga gccaggcact tcctcctttg aaacttaagg agagaggtac
      301 acagggcgtt tgtaaacgag gcatcaaaga cagtatctca gaaagctatg tgtgtgtttg
      361 tgtacgtatt tgccaacaag tctctgtgct tttgtcttct aagccccaag gtcttttagt
      421 tcattcttta tgcttcgtgt gtgtgtgtgt gtgtgtgtgt gtgtgtgtgt attctgggga
      481 tcaatcccag gacctccttg catgctaggc aagcactgta ccaccaagtg acacacccag
      541 tcacctcaac tactttttct aagtaaagca aacaggaggg gctagggatg tgtctgcctg
      601 cagagagctt gcctagcatg gattgggttt gatctcccac aggacatagg ccgggcagtg
      661 caatgcatga ctataatcat gatgtttgga aggtggggac aggaagttca gaacctcagt
      721 gtcaccctta gccatgcagc aagtgtgagg ccaatttggg acatatgaga cctgtcccca
      781 aaaataaatc tgacagcagg gcatagcgca atctgttgtt catcccagca cttgaaaggc
      841 agaggcaggc agatctctgt cagttcaagg ccagcctggt ctacatagca agttccagaa
      901 cagcctgggc tacccactaa gactctgtct aataagtgca taaatacaaa gtaatgaata
      961 cagaattgat cacattgagt ctttgggctc tataagacag ctcatatagt acattctaag
     1021 acagccagag ctacatacat agtgagactc tgtcttgaag aggaaaaaaa aaaggcatgt
     1081 tagattgatg atgtattaga agtctagact acagagtgag ctcaaggaat gggctcaaag
     1141 ccagcccagg aagcttaaaa attctttgtc tcaaataaaa agtttaattt gggctagaga
     1201 ggtggctcaa gggttaagaa ctcacgtggc ctttctgaga acctaggctc tgttcccagc
     1261 atccacatca ggcaactcac agatttggtt tccccagctt caggggattc aaccccctct
     1321 tcaagatcct gcaggcatcc acatgtgtgt ggtgctcact cgcacagaca cgcacatgta
     1381 cacaggtaaa tgataaaatg cattttcatt atttgtatgt ctgagtacct tagttacttt
     1441 tctatcgtta ggatgaaaca ccaggaccaa aacaacttct agaggaagga tttagttggg
     1501 cttacacttt gtttctttgt ctttctttct ttgtttcttt ctttgtttgt ttgtttcttt
     1561 ctttctttct ctctttcttc cttcctttct ctctctctct ctctctctct ctctctctct
     1621 ctctctctct ctctctcttt ctttctttaa ttgaaggtcc cgcactggtc ctgcttccac
     1681 aagtccatta gtgcccaaga tcaaggagaa aggaagaaca accagataag gcaggaaggg
     1741 ttatttcccg aacattccat ttacacacag aactaaacag gtaagtcact attgctctta
     1801 gaagtaggca gcatgggaca gggagagatg gggaatagga gtgtatttaa aaagaacaca
     1861 gggggcacgt tcgttatcgt attcctttct gctctttgac gctgcagagg aagcatcgct
     1921 gaaggctctc gtaactctac catcatgtct aagtccgagt ctcccaagga gccagaacag
     1981 ctgtggaagc tctttattgg agggctgagc ttcgaaacaa ccgacaagag tctgaggagc
     2041 catttagagc aatggggaac actaaccgac tgtgtgggaa tgagagatcc aaacaccaag
     2101 agatccaggg gctttgggtt tgtcacatac gccactgtgg aagaagtgga tgctgccatg
     2161 aatgcaagac cacacaaggt ggatggaaga gttgtggaac ctaagagagc tgtctcaaga
     2221 gaagattctc agtgaccagg tgcccagtta actgtgaaaa agatctttgt tggtggtatt
     2281 aaagaagaca ctgaagaaca tcacctacga gattattttg agcagtatgg gaagattgaa
     2341 gtggtagaaa ttatgactga cagaggcagt gggaaaaaga ggggctttgc ttttgttacc
     2401 tttgatgacc atgactctgt ggataagatt gttattcaga aataccatac tgtgaatggc
     2461 cacaactgtg aagtaagaaa ggctctgtcg aagcaagaga tggctagtgc ttcatccagc
     2521 cagagaggtc gcagtggttc tggaaacttt ggtggtggtc gtggaggcgg ttttggtggc
     2581 aatgacaatt ttggtcgagg agggaacttc agtggtcgtg gtggctttgg tggcagccgt
     2641 ggtggtggtg gatatggtgg cagtggggat ggctataatg gatttggcaa tgacggtggt
     2701 tatggaggag gtggccctgg ttactctgga ggaagcagag gctatggaag gggtggacag
     2761 ggttatggaa accagggcag tggctatggt gggagtggca gctatgacag ctataacaac
     2821 ggaggaggca gagacagctt tggcggtgga agcaattttg taggtggtgg aagctacaat
     2881 gattttggca attacaacaa tcagtcttca aattttggac tgaagaaggg aggaaacttt
     2941 ggaggcagga gctctggctc ttatggtggt ggaggccagt actttgctaa accacgaaac
     3001 caaggtggct atggcggttc cagcagcagc agtagctatg gcagtggcag gaggttctaa
     3061 ttacgtacag ccaggaaaca aagcttagca ggagaggaga gccagagaag tgacagggaa
     3121 gctacaggtt acaacagatt tgtgaactca gccaagcaca gtggtgacag ggcctagctg
     3181 ctacaaagaa gacatgcttt agacaatact catgtgtgtg ggcaaaaact ccaggactgt
     3241 atttgtgact aattgtataa caggttattt ttagtttctg ttctgtggaa agtgtaaagc
     3301 attccaacaa aaggttttac tgtagacctt tttcacccag gatgttgatt gctaaatgta
     3361 atagtctgat catgacgctg aataaatgtg tctttttttt tttaaatgtg ctgtgtaaag
     3421 ttagtctatt ctgaagtcat cttggtaaac ttccccaaca gtgtgaagtt agaattcctt
     3481 cagggtggtg ccaagttcca tttggaattt atttatggtt gcttgggtgg agaagccatt
     3541 gtcttcaaaa accttgatgt cgttaaactg ccagttacta ttgtaacttt taatgagttt
     3601 caccattgaa agggtcatcc aagcaaggtc acaatttggt tataaaatgg ttgttggcac
     3661 acgctatgca atatcaaaat tgaataatgg tatcagataa aataacagat gggaatgaaa
     3721 cttatgtatc cattatcatg tgtactcaat aaacgattta attctcttga aaaaaaaaaa
     3781 aaaagaacac aggctccccc ctaaaccgag tgcttggcct gtttcaaccc aagaggaatc
     3841 aaagtatcaa gatctgtttg ggaaggccag accaccaggg atggagggag gacagtccag
     3901 agggtgggag tgaagagatt gcccccaccc ctgctgagaa tcccctaccc ctaaggtctg
     3961 gcaggaaagg ggcagccctg ctatacttca gagcaagttt agggctgcca gatggctgct
     4021 agatgctagg ggggccggag gtggctcaca taggcatccc ctcagggaga tgatagggct
     4081 gccacttagt ttttctacca gagttcaggg gtccttaacc tcctcagaag cagtttcctt
     4141 ttaattcatg cttgattcct gtcagcttct tcttgatggc atccttggag ctggtataga
     4201 ttgtttttga tcttgaggca agcaccagag aagtgcccac tagctggcag agcaaagagc
     4261 tcgggagaag cctcaactca attgtctgaa taatcagatc taagacaaaa gagaagcaaa
     4321 caagcacagc aaattcaaaa ggcaccaagg gcacccaagg ggcagttcca gaaacaagga
     4381 caagcaaggc accggagtgg ctttggtaag aaactctggg gtccaaagcc agacctggcc
     4441 cgcaaggctt attagcagaa tgctcacctt ggagttttta taaggaaaac agagagttgc
     4501 aagtctggca ggaaattata ccctcactcc cagagctgca gctggcttga actatcctat
     4561 tcccactgtt aggactccag agcactggtc ctttcctcat ggaccctcgc agcctgcaag
     4621 gatgacacaa gccctgttta tctccagttg aggaccaggc ctgatcttga aaagacagcc
     4681 ataagacaac agctccggga acagaccata atatccagaa acaaggtctt aaaacccgct
     4741 cccaaagaac aaccagggaa taagcacaaa aatagggaaa tatcttatct tgggatgggc
     4801 catctgtgct gggcagccct ccctcatcct aaggttaaac gtcaatgaca taggaccact
     4861 ggacacctgg gaccccctag cacccatcag tgaaatttta aattacctaa tccttctaga
     4921 gagttccccc agttccctat aagaaggcct gtgcaccttt gtctggggtc accatctcaa
     4981 aaaaactgat taatcccgat tgctggttgt ttctgcagaa taaacgctct ttgcctttgc
     5041 atactgagtc tggggtcttc cttcagtaat tttcggaccc ttacaagtcc atccaggttg
     5101 ttcctgccaa gtcccaaaga aagtcagaac aaatggctaa ctgtggggtc agcataccaa
     5161 agttgaagct ggacgctcac tctggcacct gagtcctctt agctctttgt accttaacca
     5221 tctccagctt cccttccccc agcttctgtt gccttataac cctactgttc ctgccacact
     5281 cttaaacgcg ttctcacgac cggccaggaa gaacacaaca aaccagaatc ttctgcggca
     5341 aaactttatt gcttacatct tcaggagcca ggagcgcaag ccccaagccc caaaaacgaa
     5401 agcccccccc cccccgctta catctttagg agccagagcg ccagagcgtc agagcgccag
     5461 agcgcagagc aagagagaga atggcggaaa ccccgtcccc ttttaaggag aattatcctt
     5521 cgcctaggac gcatcactcc ctgattggct gcagcccatg gccgagaaaa ggcagagtac
     5581 atgtagtgga aaattactct tggcacatgc gcagattatt tgtttaccac ttagaacaca
     5641 ggatgtcagc gccatcttgt gacggcgaat gtgggggcgg ctcccaacac cacacactct
     5701 ctgggttccc ttgattctcg tagtcaagtt cagttgggac tcttctagat gtttcttttg
     5761 tcctctccct catatctata ccttggagca gtcatatcct cagttcattg ggtcctctct
     5821 acctgtttgg ctcttcctct ctcccctcct ttgcctaacc aacctctgat ggagtgcctt
     5881 catcacacct cagattgagg tggggccagt cttgtgatta ttcctatcac tgcactcccc
     5941 tggttctata agacaataaa ctccactcct tcctgcacac gactataaac tcatacaatg
     6001 gtcagcatcc ttactcattg tatcattagc aaccatgggg cttagatcta tagacacttg
     6061 acctactggt ggatggatag gtagctgaac tagggtgggg tggggtggat ggaaagacaa
     6121 gcctgagcaa gaagaaagaa tagcagtgag gtagtgaaat agagattaaa actagaagtc
     6181 agattaaaaa cagactcctt gtgatggttt gcatatgctt ggcccaggga atggcactat
     6241 taggagatgt gaccttcctg gagtaggtgt gtcactgtgg ggatgggatt aagaccctca
     6301 ttttagctgc ctagaggcca gtcctccact agccgctttc agatgaagac atagaactct
     6361 cagctctgcc tgtaccatgc ctgcctggat gctgccatgt tctcaccttg atgacgatgg
     6421 attgaacctc tgaacctgta agccagcccc aattaaatat tgtccttata agagttgtct
     6481 tggtcatggt gtctgttcac agcagtaaaa ccctaactaa gacactcctg taattgaaaa
     6541 tatctacgga agaaagactt tacatgacta tgatgtccag aatatagata caggtaacag
     6601 ttgctgtcca gcctggaaga caactgtggt ggaaatttta tgcagagatt tcactgcacc
     6661 ggtgcttgat gtgaaagaag aaagtgtgga gtctcataaa aattaaacga agcagaaagc
     6721 tgcattgcct gttacaacca gagatcttgg aaaggggggc ggggggcgga tcagagcctg
     6781 ggaatggtgg ctaaaataag gtgacttgcc cagtaagaag gggaatcaca gaggaaaccc
     6841 agtcactact ggaaacccag tcactactgg agataccacc tgcatgggta agacaagaaa
     6901 gaggggaaac agccaccagc cttttctctg atgtaccact gccctccagg ctataatgtc
     6961 tgttattgta atgtattgta ttgtaatcct catccaccca ggttgctcct gccatgtccc
     7021 aaagaaactt taggacaaac tgaagggagt ttgggagttg ttatggtttg tatatgctca
     7081 gcccagggag tggcactatt ggaaaatgtg gccctgttgg agtaggtgtg gccttgttgg
     7141 agtaggcttg tcactctggg tatggacttt aacaccctca tcttagctgc ctggaagcag
     7201 tattctgcaa gcagccttca gatgaagatg tagacctctc agttctgcct gcatcatgcc
     7261 tgcctggatg ctgtcatgtt cccactttga taatgatgga ctgagcctct gaccctgtta
     7321 tacattgccc tttacaagac ttgccttggt catggtgcct attcatggca gtaaaaccct
     7381 aactaagaca gaaatgtaat ttgcaaggat gagagtcccc tattcaaaat aaagcaaatc
     7441 agcccaggac tagcgatcag atctaggtgt gaatagtagc agagaggatc ctggtaacca
     7501 ggaggctgca gccaccacct gaccttcctt ccaggggtga aaagatcttg gtgaaggaga
     7561 cagagtactg tggcctgggg ccaaggagct tagcacaggc cactatttct aatgacttgt
     7621 agggctagta aggaacagaa aggtgtgttg tgccggctag ttttgtcaac ttggcacaac
     7681 ccaggatcat ctgggaagag ggaacttcaa ctgagaaaat gcctgcatca aacaggtctg
     7741 tgggtaaatc tttagggcat tttcttgatt actgattgat gagacccacg gagtgttttc
     7801 tgtgctctgc agtcatgggt atagaacttg cctcttaaat accaccaaga ctagccacct
     7861 gaccatgtgt gtgacccaca cttgaggatt tccatttctc acaagctgtt tattctgtct
     7921 ttatgtaaag ccctaaggca tttgctctat ttgacagtga ggaaactgaa actctgagaa
     7981 atgagaaata gagccagtca tggaggtgtg tgcctataac tccagcactc aggagctgga
     8041 ggcaagcgaa cagggaattc caagccagcc tgggcttcct agcaagaccc tgactcaaaa
     8101 aaactaacta taaataagaa ccaagtttga aggaatttgg acaatgtcat gaaaattatc
     8161 tcaaacttgg aagtaagaaa aagagattgc tgtaagtcta tagctcaaac ttgcacaaag
     8221 aaactgaagg ggacaatttt gccccagaca ctccaagaga cgatattgca gtgtctagaa
     8281 acattagagt atagcaactt aatctggagt gggcactact gccacctagt ggttggagtc
     8341 taggattgct gctgaaactc agactggggc aaccccacag caaggaggtc aaagggtcat
     8401 cattgagaaa tcctcaagga gagcatgacc acacttgacc tatgactgac tactagttgt
     8461 gtctccagca catcaacatg tagagcgctg ttttcaggcc tttgacttct gactcggcag
     8521 ctaccccagg cagtacaacg tgtgtggagt ctgcagcaat tgggtcttct tgtcaagttc
     8581 tggtggacag tcgggagcaa tgacaatagt ctgtattgtt ggggagactg tttgaacctc
     8641 tcttaccaac agcttgtggg gaggtagctt acacttggct tgtttttctt tatgtggtgt
     8701 cgaacccaca gctttgtact attgagttag agccctaacc ttaccctctc ttcataaata
     8761 cagatataca ctggatttgg ggtcgtatga ccttatacaa ccttagtcac ttctttcaag
     8821 gttctggatg caaatacagt ttggtcagaa tgtattgggg aatgagattt tctgcaggga
     8881 acttgaagga catttcagct cattatatat ctctatttca ttgttaacat ctgcagggca
     8941 ggtggtcctg agttgtataa aaagcaggct aagcaagtca tttggagcaa gctagtaagc
     9001 agcactcccc cgggacacac acacaccaaa acacaccccc gcccatggtc tctgtttcgt
     9061 ttcctgctga gttcctgtcc tgaactccct tgtgtgtcca tgagaagcat gcttctcacc
     9121 tgttgaatgc tgtgctgtac agatacagca gctgagccca caaagccatg tgtatttcta
     9181 tcacagcaca gagcttcctt gagggacagc tgctacatct atgccaactc cttaatcaat
     9241 acaagccacc ctctaaggct gatatctcag agctgaggat ggggctcaaa gatggagcac
     9301 ttgccataca tgccgaatgt ggtgacagac acatttaaac ccagcacttg agaggcagag
     9361 gcagatgaat ttctgtgagt ctgacgccag cctggtctac agagcaagtt ccaggtcagt
     9421 caggattgta tagtgagacc ttgtctcaaa aagcaaacaa caacaacaac aaaatccaca
     9481 aataaataac atgttgttcc aaccacacca cctgcctcta tctttgtgac ccctcagata
     9541 aatctccaag aataattttg gttttgtaga gatgagagcc ctctcccaaa tgctgactcc
     9601 taggacccca aggcatgctg ctggaagtca ggcccagcaa ataagcccaa cctcctctct
     9661 tctgggcatc acacatttca tagttagcaa ttattattta aattagtgct gtttcttacc
     9721 tattctcaaa aacactcata tcagttaact gattcacaca ctttattaat cagtaggggt
     9781 tttggggttt tttattttct atttttttat ttttttaggt ttagtttagt ttttggtttt
     9841 ctgagacagg ggttctctgt gtaattctga ctgttctgga actcgatctg tagaccaggc
     9901 tgacctcgaa ctcacagaga tctgcctacc tctgcctcct gagtgctggg attaaaggca
     9961 tgcgccgcca ccaccacctg gcatgagtca attctatgtt aagctcacag cagtgtatca
    10021 gaggcatgcc agagtttgga tactgagtgc taccagtctc ctgggacaca aggagctgtt
    10081 cccagctcct cagtaaacag cgctatgtcc ttggcagatg ttagggagga acaccttgaa
    10141 cttctctgat ctataagtaa atgaacaggc ttacagtccc ccatcgtgga agtcattgtt
    10201 ttgggaatat gtgcaacatc acttccgacc ggaatagcta tcactggaac tttccatgcc
    10261 tcttcaccag aacgtgcccc tccctggtac tggcttctgt ggtttgaatg cttttgtcaa
    10321 ctccatgaat tcttcttgag acccttaaca cacacacaca cacacacaca cacacacaca
    10381 cacacacaca ccagtattgg aagatgttgc ctttggatgg gtctgggtca tgagggctca
    10441 acccttgcta tacacagggc ttgttggagg cctttctgtt gtgtgaggaa cagcattctt
    10501 ctcttcctct ccagaggatc catttctgtt ctttataatc taaccagcct caggcagtac
    10561 attacagcag cacagaatgg accatgatgc tgaccggtag cgtagccctc actgttttgc
    10621 agactattgg cttccatgga tgggcacatg atcccagaga gccagttaga gctgtgatat
    10681 tgaaactaag aaaaactcct tttctaagac agagggtgta agagccctcg gaccagaaat
    10741 caggaagcca gggttctaac tccccttcaa tcagggggga gtcacttaat atgtcagggc
    10801 ttccaattcc atatctgaaa attagctaca ggtcagagag ggagaaggag aggaaggaag
    10861 gagagagaga aagagagagg gggagggttg cattagcagt cactacaaac ttcccctttc
    10921 ctttgtggct ttttgtggga aatcagaagc aatagtatcc caagtcaggt ggtacatgga
    10981 ggatgttctt aaacgctttg ctgctgaccg ctgctgtcat tcaatccttc ttgagaccct
    11041 ggaggcaaaa gactcctctg acactgtctc ttaactcttg aagctcagag ttctccagtg
    11101 tcataatggc aacccgagac aatgcacaga ctccttctca cactgacata aaagccagga
    11161 gaactaccag gagtgtgagg aacctgttgg ggctgctggg ggggaaaaaa aaaaaaacag
    11221 ctatgaggag aaccaatcac cagtcctgac tactcctcat ccaagaagca ttcgggtact
    11281 tcagccgggc acttccttat tcctactgtt gtttcagaat cccatacatg tatacaatgt
    11341 gttttcgatc aaactcacct gccactccca actcctaccg aaccacccca cccctcctcc
    11401 caattttatg ttccttttta aatttttatt tatttatgtg tttatttgtt tatttactta
    11461 tttattttga ctaggtctca ctatgtagct ccggctgttc tgaaactcac tatgtagctc
    11521 aagctggcct cgaactccat atacctgact ctgcctctcg ggtgctggga ttaaaggtgt
    11581 acactaccac cgctctgaat tttttttttt ttaaaccgac tccacttagc cctaacagtg
    11641 tatacagtgt aggaccatcc ccatggagct aggacagcca atcagaggcc atatcccaga
    11701 agaaaactca ccctccctca tcctatagcc atcagcaacc aatagttcct cggctgagcc
    11761 tggggctacg gaagcccctc ctccattcat gctgcctggt acttctattg cctaagagat
    11821 gcggaatttg agatgatcgg gcagttgaag ctagctgtta gaactagttt tgttttgttt
    11881 tttaagcaaa gctattttga tcaccagcgt atcttcagaa tcacccacta ccactctgta
    11941 aaattgttgt cagcgaataa acttgcaggg gtcagtgttt acacactagt gctgcccaag
    12001 ggatacgttg cgagtttggc gcagagcagg ttctgggttc tggttaaagg tctgcacagg
    12061 gctgtagtgc tggacctgcg cgcaggagcc cagccgcggc gctcgggggg gggggggggc
    12121 gggggggggc gggggggggg cacggccacc aggtggcacc accgagtcct cgcgcggggc
    12181 ggagcggccg cggagctgga gtagcatgtg ggcgttcgga ggtcgcgcag ccgtgggctt
    12241 gctgccccgg acggcgtccc gggcctccgc ctgggtcggg aacccgcgct ggagggaacc
    12301 gatcgtaacc tgcggccgcc gaggcctaca tgtcacagtc aacgccggcg ccacccgcca
    12361 cgccgtgagt acgcgcttcg ccgggccgca caccggagcg caggccgcgc ccgcccctat
    12421 gccggggacg cgcagcgcgc acgcgccgag tcgctctggt tgcgcgcgcg tttgggtgca
    12481 gggcgcgcgc ggtgtttgcg cgggcttcgg accttggcgg tggggatggg aaaagacgag
    12541 tttccgtaat taacacagga tgtatagcgt gtgcagcagg gcgtgtttat tattgtgtgc
    12601 actccgaagt tgcctttttc agggcgtgag actaatgggg ttgtggagtt gctctgagca
    12661 gggctttttg ttgcttgttt gcctcactct gtatccctgg ctagcctagg attggctgag
    12721 taccccaaag tggcttcaat cctgtgatcc tcctgcctcc tctctgctgg gatcacaggt
    12781 gtagcagcag agccctagag tccagctttt ggaaaatgag gggatcttgg ttccacgttc
    12841 tgactgcgcg gcgctggaga gccctgtgac cttggggaga ccctaactgt ctgggggcag
    12901 ggcttggctt tctgttccga ggagattaaa gggtaacacc cattttgcga ttttggcggg
    12961 agaattaaac tgtattcgca aaggccttag cacttcagat aagtctcggt tcttagtaga
    13021 tgcaaagaac agaatctgtt actccgtggc ttgaaaagac agcagtaggg tgaaggaagg
    13081 ctttccggag agggccgtga tagatgccaa agaacgggtc tggggagcat tctaggaagg
    13141 ggagagctat ggacaaaggt ggagtaggct gtgggataat aatgtctaca ggtttaaacc
    13201 cagcttagga ttcttgaggt cctgtcatta aaataaaaaa caataataaa aatagggcta
    13261 gctttgtagc tcagcagtga catggtcact tagcgttcaa gagttcttgg gttctttcta
    13321 taacactgaa aaagaaagtt taaaaacaaa acaaacaaaa gtggactggt cagagagaga
    13381 gacggctagg gtttgaaggg ccgaacctgt aacccatgct tcctcaaaca ctttcttgga
    13441 tgtttactgc cctgttcttc ccttgcctgg cgcctgacag ctgggctcca gttgcagctg
    13501 tgcactttgg atttctgcat ctctgagagc ctgagcaact ttgtctttgg catctccgtt
    13561 tcctcgcctg tacaatgcaa atacagtcgg tccatcttta tgctcagagt ctgttctcag
    13621 tggctcaata tcgtttacgg tccccagttg tctaccctga tgctcctaca gtcactttga
    13681 aagcggcaga ctggccaaaa gcgcaaggct catggaaggt gtcccctccc ggccgttgtc
    13741 caacaaggct tgattccgct gtcacggagt gagcagatat tcagtctctt cagcgaaatg
    13801 cctgtttgcg tcgatgtacc tgtgggagac tttgtcgttt gaaagtggtc cccaagccta
    13861 gagccacagt aaacatagta agattgtgga atggcttgca aagaaaatgt atgaaagaaa
    13921 cacctcactc aggtgggcag tggtggcaca ggcctttaat cccagtactt gggaggcaga
    13981 ggcaggcgga tttctgagtt cgaggccagc ctggtctaca gagtgagttc caggacagcc
    14041 agggctacac agagaaacct tgtctcgaga aaaaaaaaaa aaaaaaaaag aaagaaagaa
    14101 agaaagaaag aaagaaaaaa agaaacacct cacttcagca tgagttataa gtgttcttgc
    14161 ttcaagttca aagctgacaa accaataata tataataaat aaagtgtctt tagacagaca
    14221 tgcacaaaca gaattatgca tacgcattgg ccatttgata gttatgaccc tgagacttat
    14281 agggacccaa cctgtgcccc ctaggaacaa gtaagtgagc actgcaactc tatagggcta
    14341 ccccctccag cggatgatga tggagtaggg gatagagaga tggctcagca tttaagaaca
    14401 cttgctattc ttagagagga tctgggtttg attcctggca caaggcagcg cccaaccttc
    14461 tatcactcca gttcttggag atctgagatc ggctgccctc ttctccctcc aaggtcaccc
    14521 acatacatgc tgtgtatatc catatactca ggcacacaca cacaaaatac aagataatta
    14581 ttttttttaa aaaaaagatg atcacgatga agttcttccc tcataactcc atgagggaga
    14641 aaaggattct gtgagtccat tcagctaaag acagagcagt gccaagcaga gagagacgac
    14701 tctcgagcac atggcagctg gtgcggtgta gccatggcca cttgagatac agtcagcata
    14761 gctatcttag ccaatggaga gatgctcgat ctggtgctac ctaaccatga ccacctgagt
    14821 gagatacagc taccacagct gtcttagtca gtgttccatt gctgtgaagc gacaccatga
    14881 tcaaacattt aataggggct agctttcagt tcagaagttt aatccattat cattatggtg
    14941 ggaaagcgtg gtatcaatgc aggcagacat agcaggaaat atggtggcac ataggcagac
    15001 acagtactgg agatcagctg agaggctgca ggcagcagaa agaaagtgag aaaggcgcat
    15061 aacgatacca cgatatcaac aagtttgtac aaaaaagcag gctggcgccg gaaccaattc
    15121 agtcgactgg atccagaagg cagcaagggt cactacaccg gtgtgcttga ggacatttga
    15181 cttcgggccc gaagttccta ttcttcaaat agtataggaa cttcggcgcg cccattccta
    15241 tagcccttcg gccgaagtgt ttgtgattgg cgtcggtggc gttggcggtg cgctgctgga
    15301 gcaactgaag cgtcagcaaa gctggctgaa gaataaacat atcgacttac gtgtctgcgg
    15361 tgttgccaac tcgaaggctc tgctcaccaa tgtacatggc cttaatctgg aaaactggca
    15421 ggaagaactg gcgcaagcca aagagccgtt taatctcggg cgcttaattc gcctcgtgaa
    15481 agaatatcat ctgctgaacc cggtcataga tctgaattcc catggcatat ggagctcagg
    15541 cctaagcttg gctttcccac accaccctcc acacttgccc caaacactgc caactatgta
    15601 ggaggaaggg gttgggacta acagaagaac ccgttgtggg gaagctgttg ggagggtcac
    15661 tttatgttct tgcccaaggt cagttgggtg gcctgcttct gatgaggtgg tcccaaggtc
    15721 tggggtagaa ggtgagaggg acaggccacc aaggtcagcc ccccccccct atcccatagg
    15781 agccaggtcc ctctcctgga caggaagact gaaggggaga tgccagagac tcagtgaagc
    15841 ctggggtacc ctattggagt ccttcaagga aacaaacttg gcctcaccag gcctcagcct
    15901 tggctcctcc tgggaactct actgcccttg ggatcccctt gtagttgtgg gttacatagg
    15961 aagggggacg ggattcccct tgactggcta gcctactctt ttcttcagtc ttctccatct
    16021 cctctcacct gtctctcgac cctttcccta ggatagactt ggaaaaagat aaggggagaa
    16081 aacaaatgca aacgaggcca gaaagatttt ggctgggcat tccttccgct agcttttatt
    16141 gggatcccct agtttgtgat aggcctttta gctacatctg ccaatccatc tcattttcac
    16201 acacacacac accactttcc ttctggtcag tgggcacatg tccagcctca agtttatatc
    16261 accaccccca atgcccaaca cttgtatggc cttgggcggg tcatcccccc ccccaccccc
    16321 agtatctgca acctcaagct agcttgggtg cgttggttgt ggataagtag ctagactcca
    16381 gcaaccagta acctctgccc tttctcctcc atgacaacca ggtcccaggt cccgaaaacc
    16441 aaagaagaag aacgcagatc tccgagggca gaggaagtct tctaacatgc ggtgacgtgg
    16501 aggagaatcc cggccctggg atctggactc tagaggatcc cgtcgtttta caacgtcgtg
    16561 actgggaaaa ccctggcgtt acccaactta atcgccttgc agcacatccc cctttcgcca
    16621 gctggcgtaa tagcgaagag gcccgcaccg atcgcccttc ccaacagttg cgcagcctga
    16681 atggcgaatg gcgctttgcc tggtttccgg caccagaagc ggtgccggaa agctggctgg
    16741 agtgcgatct tcctgaggcc gatactgtcg tcgtcccctc aaactggcag atgcacggtt
    16801 acgatgcgcc catctacacc aacgtgacct atcccattac ggtcaatccg ccgtttgttc
    16861 ccacggagaa tccgacgggt tgttactcgc tcacatttaa tgttgatgaa agctggctac
    16921 aggaaggcca gacgcgaatt atttttgatg gcgttaactc ggcgtttcat ctgtggtgca
    16981 acgggcgctg ggtcggttac ggccaggaca gtcgtttgcc gtctgaattt gacctgagcg
    17041 catttttacg cgccggagaa aaccgcctcg cggtgatggt gctgcgctgg agtgacggca
    17101 gttatctgga agatcaggat atgtggcgga tgagcggcat tttccgtgac gtctcgttgc
    17161 tgcataaacc gactacacaa atcagcgatt tccatgttgc cactcgcttt aatgatgatt
    17221 tcagccgcgc tgtactggag gctgaagttc agatgtgcgg cgagttgcgt gactacctac
    17281 gggtaacagt ttctttatgg cagggtgaaa cgcaggtcgc cagcggcacc gcgcctttcg
    17341 gcggtgaaat tatcgatgag cgtggtggtt atgccgatcg cgtcacacta cgtctgaacg
    17401 tcgaaaaccc gaaactgtgg agcgccgaaa tcccgaatct ctatcgtgcg gtggttgaac
    17461 tgcacaccgc cgacggcacg ctgattgaag cagaagcctg cgatgtcggt ttccgcgagg
    17521 tgcggattga aaatggtctg ctgctgctga acggcaagcc gttgctgatt cgaggcgtta
    17581 accgtcacga gcatcatcct ctgcatggtc aggtcatgga tgagcagacg atggtgcagg
    17641 atatcctgct gatgaagcag aacaacttta acgccgtgcg ctgttcgcat tatccgaacc
    17701 atccgctgtg gtacacgctg tgcgaccgct acggcctgta tgtggtggat gaagccaata
    17761 ttgaaaccca cggcatggtg ccaatgaatc gtctgaccga tgatccgcgc tggctaccgg
    17821 cgatgagcga acgcgtaacg cgaatggtgc agcgcgatcg taatcacccg agtgtgatca
    17881 tctggtcgct ggggaatgaa tcaggccacg gcgctaatca cgacgcgctg tatcgctgga
    17941 tcaaatctgt cgatccttcc cgcccggtgc agtatgaagg cggcggagcc gacaccacgg
    18001 ccaccgatat tatttgcccg atgtacgcgc gcgtggatga agaccagccc ttcccggctg
    18061 tgccgaaatg gtccatcaaa aaatggcttt cgctacctgg agagacgcgc ccgctgatcc
    18121 tttgcgaata cgcccacgcg atgggtaaca gtcttggcgg tttcgctaaa tactggcagg
    18181 cgtttcgtca gtatccccgt ttacagggcg gcttcgtctg ggactgggtg gatcagtcgc
    18241 tgattaaata tgatgaaaac ggcaacccgt ggtcggctta cggcggtgat tttggcgata
    18301 cgccgaacga tcgccagttc tgtatgaacg gtctggtctt tgccgaccgc acgccgcatc
    18361 cagcgctgac ggaagcaaaa caccagcagc agtttttcca gttccgttta tccgggcaaa
    18421 ccatcgaagt gaccagcgaa tacctgttcc gtcatagcga taacgagctc ctgcactgga
    18481 tggtggcgct ggatggtaag ccgctggcaa gcggtgaagt gcctctggat gtcgctccac
    18541 aaggtaaaca gttgattgaa ctgcctgaac taccgcagcc ggagagcgcc gggcaactct
    18601 ggctcacagt acgcgtagtg caaccgaacg cgaccgcatg gtcagaagcc gggcacatca
    18661 gcgcctggca gcagtggcgt ctggcggaaa acctcagtgt gacgctcccc gccgcgtccc
    18721 acgccatccc gcatctgacc accagcgaaa tggatttttg catcgagctg ggtaataagc
    18781 gttggcaatt taaccgccag tcaggctttc tttcacagat gtggattggc gataaaaaac
    18841 aactgctgac gccgctgcgc gatcagttca cccgtgcacc gctggataac gacattggcg
    18901 taagtgaagc gacccgcatt gaccctaacg cctgggtcga acgctggaag gcggcgggcc
    18961 attaccaggc cgaagcagcg ttgttgcagt gcacggcaga tacacttgct gatgcggtgc
    19021 tgattacgac cgctcacgcg tggcagcatc aggggaaaac cttatttatc agccggaaaa
    19081 cctaccggat tgatggtagt ggtcaaatgg cgattaccgt tgatgttgaa gtggcgagcg
    19141 atacaccgca tccggcgcgg attggcctga actgccagct ggcgcaggta gcagagcggg
    19201 taaactggct cggattaggg ccgcaagaaa actatcccga ccgccttact gccgcctgtt
    19261 ttgaccgctg ggatctgcca ttgtcagaca tgtatacccc gtacgtcttc ccgagcgaaa
    19321 acggtctgcg ctgcgggacg cgcgaattga attatggccc acaccagtgg cgcggcgact
    19381 tccagttcaa catcagccgc tacagtcaac agcaactgat ggaaaccagc catcgccatc
    19441 tgctgcacgc ggaagaaggc acatggctga atatcgacgg tttccatatg gggattggtg
    19501 gcgacgactc ctggagcccg tcagtatcgg cggaattcca gctgagcgcc ggtcgctacc
    19561 attaccagtt ggtctggtgt caggggatcc cccgggaggg cagaggaagt cttctaacat
    19621 gcggtgacgt ggaggagaat cccggcccta ttgaacaaga tggattgcac gcaggttctc
    19681 cggccgcttg ggtggagagg ctattcggct atgactgggc acaacagaca atcggctgct
    19741 ctgatgccgc cgtgttccgg ctgtcagcgc aggggcgccc ggttcttttt gtcaagaccg
    19801 acctgtccgg tgccctgaat gaactgcagg acgaggcagc gcggctatcg tggctggcca
    19861 cgacgggcgt tccttgcgca gctgtgctcg acgttgtcac tgaagcggga agggactggc
    19921 tgctattggg cgaagtgccg gggcaggatc tcctgtcatc tcaccttgct cctgccgaga
    19981 aagtatccat catggctgat gcaatgcggc ggctgcatac gcttgatccg gctacctgcc
    20041 cattcgacca ccaagcgaaa catcgcatcg agcgagcacg tactcggatg gaagccggtc
    20101 ttgtcgatca ggatgatctg gacgaagagc atcaggggct cgcgccagcc gaactgttcg
    20161 ccaggctcaa ggcgcgcatg cccgacggcg aggatctcgt cgtgacccat ggcgatgcct
    20221 gcttgccgaa tatcatggtg gaaaatggcc gcttttctgg attcatcgac tgtggccggc
    20281 tgggtgtggc ggaccgctat caggacatag cgttggctac ccgtgatatt gctgaagagc
    20341 ttggcggcga atgggctgac cgcttcctcg tgctttacgg tatcgccgct cccgattcgc
    20401 agcgcatcgc cttctatcgc cttcttgacg agttcttctg agcgggactc tggggttcga
    20461 aatgaccgac caagcgacgc ccaacctgcc atcacgagat ttcgattcca ccgccgcctt
    20521 ctatgaaagg ttgggcttcg gaatcgtttt ccgggacgcc ggctggatga tcctccagcg
    20581 cggggatctc atgctggagt tcttcgccca ccccccggat ctaagctcta gataagtaat
    20641 gatcataatc agccatatca catctgtaga ggttttactt gctttaaaaa acctcccaca
    20701 cctccccctg aacctgaaac ataaaatgaa tgcaattgtt gttgttaact tgtttattgc
    20761 agcttataat ggttacaaat aaagcaatag catcacaaat ttcacaaata aagcattttt
    20821 ttcactgcat tctagttgtg gtttgtccaa actcatcaat gtatcttatc atgtctggat
    20881 ccgggggtac cgatcacgga cgaatgtggc tcgagtgccc caactggggt aacctttgag
    20941 ttctctcagt tgggggcgta gggtcaagct agcttaccat gaccgagtac aagcccacgg
    21001 tgcgcctcgc cacccgcgac gacgtcccca gggccgtacg caccctcgcc gccgcgttcg
    21061 ccgactaccc cgccacgcgc cacaccgtcg atccggaccg ccacatcgag cgggtcaccg
    21121 agctgcaaga actcttcctc acgcgcgtcg ggctcgacat cggcaaggtg tgggtcgcgg
    21181 acgacggcgc cgcggtggcg gtctggacca cgccggagag cgtcgaagcg ggggcggtgt
    21241 tcgccgagat cggcccgcgc atggccgagt tgagcggttc ccggctggcc gcgcagcaac
    21301 agatggaagg cctcctggcg ccgcaccggc ccaaggagcc cgcgtggttc ctggccaccg
    21361 tcggcgtctc gcccgaccac cagggcaagg gtctgggcag cgccgtcgtg ctccccggag
    21421 tggaggcggc cgagcgcgcc ggggtgcccg ccttcctgga gacctccgcg ccccgcaacc
    21481 tccccttcta cgagcggctc ggcttcaccg tcaccgccga cgtcgaggtg cccgaaggac
    21541 cgcgcacctg gtgcatgacc cgcaagcccg gtgcctgacg cccgccccac gacccgcagc
    21601 gcccgaccga aaggagcgca cgaccccatg catcgatgat atcagatccc cgggatgcag
    21661 aaattgatga tctattaaac aataaagatg tccactaaaa tggaagtttt tcctgtcata
    21721 ctttgttaag aagggtgaga acagagtacc tacattttga atggaaggat tggagctacg
    21781 ggggtggggg tggggtggga ttagataaat gcctgctctt tactgaaggc tctttactat
    21841 tgctttatga taatgtttca tagttggata tcataattta aacaagcaaa accaaattaa
    21901 gggccagctc attcctccca ctcatgatct atagatctat agatctctcg tgggatcatt
    21961 gtttttctct tgattcccac tttgtggttc taagtactgt ggtttccaaa tgtgtcagtt
    22021 tcatagcctg aagaacgaga tcagcagcct ctgttccaca tacacttcat tctcagtatt
    22081 gttttgccaa gttctaattc catcagaagc tggtcgactc tagatgcggc cgatcccccg
    22141 ggctgcagaa gttcctatac tttctagaga ataggaactt cggccggccc acacggactt
    22201 cgatgttcct cgagatatct agacccagct ttcttgtaca aagtggttga tatctctata
    22261 gtcgcagtag gcggttcccc cagcatcctg gttgagaaag aacgtacagc tataacaaat
    22321 gtaacggttc tccaggctgc ccaaggtttg ctttccacca tgatgtgagt tgaggaacct
    22381 gcctccagtg acacagtgtg atgtccaagt tagatcagcc tgcccaggtt ccatttggta
    22441 ggaagagttg gaagcactga gaggctaaaa ctagtgctgg tccttccctc actttgttcc
    22501 cgtggaccaa actcagttgc ataaggaagc tggaaagaag atagcaaggg tcttcaggaa
    22561 aacggcagtg gattccctgt ggagccacga tgcctcagtt tacatcttta ctacttgctt
    22621 atctatagga ccctttttca tgtgcagtgg tgtccccagc cccagagaca ccaaccaaag
    22681 gcatacaggg gttgctacat ccactttgaa gtccaagatg cctgagtgac attcagtact
    22741 ctaagccata gaaatgcctt tgtgtctgcc agtctgtgca gatctgtctc tcctctttct
    22801 ctctttctct gtctctgtct ctgtctctct ctctttctct ctctctctct ctctctctct
    22861 ctctcacaca cacacacaca cacacacaca cacacccctt cttggtttaa cagaagcctt
    22921 tggtgttcca agcctttgat tctcccttgg actcttccaa catgaagcta ctcttccatc
    22981 ctgtccattc catcgcctta taaagaggcc acttgtctcc cagctcagca tctctttggt
    23041 gagcttaccg tgcaagcctg gcagcttgga tttgatctct gggcacatgg agaggtggaa
    23101 ggagagaaca gttccacaca gttattcttt acctccatgg gcaagccgtg gcgcgtgcac
    23161 gtgcagacgc taataaataa taaatgtaat taaaaaacaa aaacaaaaag acaattccag
    23221 ctgtcctgaa gagttcctcg agacacccca acccaccctc catcttcact ctctccattt
    23281 caacctcgaa atgtccatca cagcctatca gaccaaccac tgtatttaga gagtagctcc
    23341 taccattctg gtcagtccca tagcccgtcc gtgttgtgcc ctaccaagag gatgggctgg
    23401 gtaaaggatg gatcagatgc tgttagcacc cagcagtcgc tggtggctta ctgtaggccc
    23461 ctggttacct ccactggggc acaaaagccc acagaaggaa ggcttaatgc attatattcc
    23521 ttcatcctgt cgttggggat ggaacccagg cctttatact tggtaattca tatctaactc
    23581 ccagacactt cccagtgcag cagtggtttt cttgtcatag ttcaggtgac atggacacca
    23641 tcagaggtga tagtccttag cacctacagc tgttaccact atctaattca gggagtgttc
    23701 acccctcccg aaaggaattc tgtgcacttc attagtcagt ggtccctccg tcctactgct
    23761 cccagaccta ctgatcaact gacctctatg ggttcataga aatgtgcaag gattttggag
    23821 ggtcgtgtct gtctgtccat ctgcctgtct gtctgtctgt ctgttttaga ccgagtctct
    23881 ctatattgcc caggctgatg ttgaactcac agtcctcctg cctcagccct ggcagattgt
    23941 gggagtagaa caataggctg gattttgctg gtgcattcct gcaatcccgg cagtcggtcg
    24001 ccggcacggg caggaagtta gcctgcactg cagagtaaca gcctgtctca aaaagaaaag
    24061 aatttttaat taaaaataaa acctgacaaa ctatagagaa acgttccata gggtttcagc
    24121 tgcatatttt tcccaaaact gaattgcaag agatagagag aacacactgt gaaatcggtt
    24181 ccagcccaag aaacagacta ccaaggactg gggagatgtt aaaagcactt gcagctcttg
    24241 cagaagactc cggttgtgtg tgtgtgtgtg tgtatatata tgtatatgta tatatatatg
    24301 tgtgtgtgtg tgtatatata tatatatata tatatatata tatatatata tatatatata
    24361 tatatacaca agcaaacacc tatacacatg ctattaaata ataaaagtaa atcttcaaat
    24421 taggagagag agagagagag agagagagag agagagagag agagagagag actgtcagta
    24481 gagcctgggc aagcaccctg ctcgctccaa gtctaatatt aaccccttta gcatagctgc
    24541 cattctgatc tatagctgct tgaattggct tttatggttg tttattttgc acacactcca
    24601 tgtggctgag taccaatgtg tctgtatgca gctcatccca tcactgtcat ttgtgacatc
    24661 tgtcacattg ctctcagagt cttagacgat tctatcttgt taggtggtgg tccttagctg
    24721 gagctcagtg caattcttct ctcctgttat cttcatacct gggcgtttcc cagtttggtg
    24781 ctatgagata gcttcaatcc aaccatgcta aaataataca cctcctgtag tgaccctggg
    24841 agtttctatt gtgcatattc ccgagagtgg gcctgaaggg ccacaggaaa ggccacagcc
    24901 tgtgagcatg ttccacagtg gtttccaaag caactgatct ctgcctgccc ctcagcagca
    24961 gaaagccctg cttgccccac ctcctgtgcc tttcatgaca tatctcattt ttaaatcttc
    25021 tttttaaaat attaacaaag ttgatcatgc tcacaggtca tgtggccatc tcttatgtaa
    25081 tcggtgcaca ctattttacc acttttctgt tggatattcc tcttattgat ttgtattctg
    25141 gtttagtcca ttttcagata tatataatac aaatattttt tccccacttt gtgtcttgac
    25201 caacaaatat ttagtaacaa aagcaatgaa aacagcccca gtgtccagca agagtggatg
    25261 tgtaaaatac agaaaatata atgaactaga cacagtagta gagtacacat ctttaatcac
    25321 agctgcttgg gaaactgagg caggagaatt gtaaatccaa agccaacctg agctacctag
    25381 gaagagcttg tctcagagaa aacaaacaag gtacttcgtt cttatatttt taaaaattta
    25441 aaggcgtcta ggagatcaca gaaaagactt ggcagatgtg actgcctctg gcgatggtcg
    25501 ccatttggaa aagaggctgc ttttctctgt aactccttta tgcagttaaa gtttttactc
    25561 tgtgcatgct gggtagtttc catcaattta aaaatataaa tgaggggctg gagagatggc
    25621 ttagtggtta agagcacttg gtgctgtacc agaggacccc ggttcacttc tcagcaccta
    25681 catggcatct catgactgtc tgtaactcca ggtccagggg ctctgacacc ctcacacaga
    25741 catgcaggca aaacaccatg cacataaaat aaaaataagt cgtttaaaaa ccgataaact
    25801 ggggcctagc aaacacagaa gtggatgttc acagtcagct gttggatgga tcacagggcc
    25861 cccaatggag gagctagaga aagtatccaa ggagctaaag agatctgcaa ccctatcggt
    25921 ggaacaacat tatgaactaa ccagtacccc agagctcttg actctagctg catatgtatc
    25981 aaaaagatgg cctagtcggc catcactgga aagagaggcc cattggtcag gcaaacttta
    26041 tatgctccag tacaggggaa cgccagggcc aaaaaatggg aatgggtggg taggggagtg
    26101 ggggggtgtg tgggggggac ttttgggata gcattggaaa tgtaattgag gaaaatacgt
    26161 aataaaaaaa aaaaagaaaa aaaacccgat aaactcaatt gtcatttaag aactaaatga
    26221 gctgggcagt ggtggtgcac gcctttaatc ccagcacttg ggaggcagag acaggcggat
    26281 ttctgagttt gaggccagct tggtctacag ggtgagtttc aggacagcca ggactacaca
    26341 gagaaaccct gtctcgaaaa aaaaaaaaaa aaaaagaact aaatgaaagg tgagtggatg
    26401 agaaaagcta ggcctggtgt ctctcacagc tgtgacgtca acaattctga ggctggggca
    26461 agccggagtg ctgctgtgtg agtttgaaac ctcccagaac tacctagcca gactctgcct
    26521 caagacccag gaaagataaa ggtagataca tcattttggt gttaacggga agtgacttgg
    26581 agaatcaagg tggctgacgg agcaggaagg actgttgtga accctagtgc ttgggtctca
    26641 cccacactcc atcttgctag ctggttactt ctgctagaaa gccttttttt tttttttttt
    26701 tttcagtttg tatgtattta ttatgactgc agttggtaac attgtctggg gttttccccc
    26761 tgcagctctc tagacgagac agcgtatgaa agactggcgg aagagaccct ggactccctg
    26821 gccgagttct ttgaagacct cgcagacaag ccctataccc tggaggacta cgatgtctct
    26881 tttggggtac ctcttggctc tgttgcgttc tgtcttctcc ttaataacgg taacttaggc
    26941 tggagaggta gttcggttgg tggagtgctt gcctggcata cacagaacct tgggttcaat
    27001 cctcagcgcc acccacagtt aggcttagta gcaaatccct gtagtcctag ttaactccgg
    27061 aagcagaggc cggaggatta gaaattcaag gccatctcca gcaacattgc aaggttgaag
    27121 ggagcccagg ctatagccct gggcgaggat ctggatttgc aaatcttccc tgtgtgtggc
    27181 tgagagagac ttcggaactg gttgaagcat tagcccagcc gctgtaagtg agggaagttt
    27241 acatgctggc caccaggtgg caggctaagc aaggatctgc ttaagctttt accatgggag
    27301 aaatatgtgt ctcctcctcg tgttcttacc cgttcccctc ctccacactc ccaatccggg
    27361 cagaggttaa tcctcttgag agcaattcat taataccagg aaatgtcatg aagtgtgcat
    27421 tttggagtga gtcatagggc tatgtagggc agatggctgt caaaaggggg ggggggcggg
    27481 aataaaaagt actttcagat tcattctttt tattccttag tacgtcacat gtatgtgaag
    27541 gtacatggtt tatcatgaca tctcccatta ggtctatttc tacttctaag ggtgaccagg
    27601 agacagccgt ctttgccgtt ttagttcctg cagggcaggg ctggctaatc ttcactgggc
    27661 ctaagcctgg ccagctagga tttgttctgc tctgattggt tggtgcgagg gtctcctctg
    27721 attggtcacc gttccttagc aattgcttag tagtttgttt ttctctcttg tggtttgatc
    27781 tgtgttgaag gccaggttcc cagctgagag gtgactgggt catgaggtcc ctgacctaac
    27841 tgaagcattg atccaaggct ggcgtcgtga ctctgtggac cacaggggaa cagtggagag
    27901 tatggcagga gctgggggct gtgggaggtt ggaagaagtc attggcggaa tgtcttcaaa
    27961 gatgctcctt atcggtggcc tctttcccct ctttgcttcc tggctgccat gaggaacagt
    28021 ttcccaccat gcccttctgc catgaggaac agtttcccac cataccctcc tgccgctgtg
    28081 tgccatgcct caaccctgaa acaacacagc cagccaccca cggactgtgt cagtcttccc
    28141 ttatgttttc tcaaatattt gtcacagcaa ggaaagtctg cataacacag tcccttcccc
    28201 tgatcttaaa tatacccaca ctcccaaaat ggactcacgt tggctaaaga acggcagtgg
    28261 ggagctgaaa accttccctg tgtaatctgc ttgcagacag ttctaaatgc cttaatgccc
    28321 ctggtaagcc agcatagcag ctggcttatc cccccccccc cctcggcctt tgtcatttgg
    28381 gatggctgga agtcctaggg gaagcgtcta atcactgtag cctggctgat agccggcact
    28441 gagctccgta gtctccacct tagcaacctt acccttcact tcggcagata gtaccatagg
    28501 gtgtctggtc actgtctgtc catgggttca tccatccaca aacataatat cattcccgtg
    28561 tttgggctga agcatgtaaa atgttgacgg agtctgagat tgagattgtc tgttcttagg
    28621 ggctcaaaat ggtggaaatg gtggggggac agcaggcccc ctgacataca agtcgatgca
    28681 gaggcagttc aaagcaggag atagtctgta aggactctgc caagtggaga gccccaggta
    28741 gccttcccag agccacctgc acagtcccgg agcaagaggg gacttcaggg aggatgctgg
    28801 aagacagccc aagcactgca agtcaggtct ctcatgggtg gctttctgct tggcttattt
    28861 tggttttgga acacacaact gtttaattaa tatccactcc tggatctctc caaagactgg
    28921 ggatcagaga gtaaattgag aacgcagtgg ttaggagagc tgtccctggt gtggtcacct
    28981 agctgtagaa ggtgacaggt acaggtgtgg agcccttgag gaggccaggc agatgttggg
    29041 agccaagcca gagtgatgca acttgtgcag gcccaggctg gttaggaagg agagcagacc
    29101 tggaagtcac atctggagag ttagtccttg gcattcattt gcgctggacc ttcaggcctc
    29161 gccacgggtg gaacacccag ggggacattt attgcctggg taagtcagag gtgactgatt
    29221 tcactgagtg ttagcctata gctagcagca gaaaactgtg gaattgggta gagagccatg
    29281 tgtttgggag aagttaacat tgaatgtgta tacagggttt cagtttttac aatgtggggg
    29341 tatttctgaa tggctctaga gtaacaatat gaatggactc aatactactc cactgtgtaa
    29401 cttagttagt tacaggcaaa tttaatgttt ttttttccca aagataaaag agagaaaata
    29461 tataaactag cagccgagaa tgaaggttcc agagggggaa cgggttgcct acaagaaaaa
    29521 ctgcttttga gcccaaacgg ccctgctttt cagcaactct actggttgct aatattttgc
    29581 tttgtttttt gccaccatga acctctttgg caaaactgag atagtgagtc ctacctccac
    29641 actgtggtct agttgaaaac agttaccttg tccagacaca gatccaggca cacactgggc
    29701 tctaagtcag aggttctcaa cctgtggctt gtgacccctt tggcaaacct ctatctccaa
    29761 atatacatta tgattcataa cggtagaaaa attacagtta tgaagtagta acaaaaagtg
    29821 ttatgattga aggtcaccac aacattagga actgtgttgt actagaaagg ttacaaaccc
    29881 ctggcctaaa taaagagaga ttagtatgtc tgtagaaggt ctgtctgggt ttgttctgcc
    29941 tgaatgccca catctccatc aggaactttt gtggggttgg tttgtgtcgc ttgtttttgt
    30001 cgttgttgtt gttgttgcta tcttgtttca ttttttgata gggtttcacg ttgcccaggc
    30061 tggcctcaac taggatgtag ccaaggatgg ccttgagttt ctgatcttct accacctgag
    30121 ccctgggatt acgaagcctg acccctgtgg ggagggaacc cagagccttg tgtgtcatag
    30181 gcaaggattc tcccagggga gcctcagcat cagacctatc tcttccttgg caaacagagg
    30241 cacaaatatt acaaggttgt taccttcctg aattacctaa tgaaacccta tctcagagag
    30301 agagagagag agagagagag agagagagag agagaagaga gcactactgt cccctcccgt
    30361 gtctattggt tacattatta tccatcccag cctctagttt atataaatgg ttggctgtgt
    30421 ttctaagagt gtgctgtgag aatccgtcca agtctcctga ttggattggc cctctgcaga
    30481 gtgcacagaa aggcgggggt gcatctgggc aacaagaggc tcccacctgc tttccagaag
    30541 caatacccgg cccctttaaa gtgtgcttag tgcctagcct ttgtttcata ttctgcattc
    30601 taaggagact aaagccctca gagtgaaggg ctcctttgtg gggtgctttc aaatttaaat
    30661 gttcatttat tgggtaaaaa tggactggcc agtcttttga gagtgcaagg ctttttagag
    30721 ggaactaaag ctgtatggag tctggagcac tcgctggatg tctgggaagg gtctggaact
    30781 aacacaggta ggcctgggcc gctccgtccg ctcttctaag acaaacgaga aagggcatgg
    30841 attactttct tctccttttc tgttttgcgt tctgtggtgc agcctgctgg cctcaaactc
    30901 accatccccc accttagcct cccaaatcct gaccttacag attttgccac cacaatcact
    30961 ttctttccgt gttttcgtga tggactcagg tctgacactt ggacagacgc tgttagagtt
    31021 tagtctgcgt tagtacgtgt tgcggttggc tagcggtcct gtttaccatg gctgagatct
    31081 caggcaagac ttaacttgtc ttggcgacca cacaggcaga gagaaagcgc tatgagcttc
    31141 aggcattcat cgtatgctat tacgattcat tcactcgtgg tggctgcaga gatggctccg
    31201 tggttaaacg cttgctactt tatcatgaga accagagcct ggatcccagc agccatatca
    31261 catcaggtgg cttatagatg cctgtaactc cggccctgca gctgtcctgt gtgtctctgg
    31321 cctctaaggg cattcatgca catacacgtg aacagaaaca cgtgcataaa taaacgtaaa
    31381 acaaacctct gaccctaaga gtaacgttct taccatacaa gctcctgttt ttgagcatta
    31441 aagtttgttt ggttttggtg ccaagaattg aacatggggt ttcccaaagc cagaacacac
    31501 tgccagtggg ctgtatcccc agcccccttt tcttaatggt gtctgttata tccttggata
    31561 catgaaaggc attgagatat gagcatgtat atgaacgcga gtgtgtatgt gcatacgtgt
    31621 gtgtgtgtgt gtgtgtttgt gtgtgtgtgt gtttgtgtat ccaaacatag gagcttgtat
    31681 ggtaaaaaca ttactctcag ggtcagaatg ggtcagaaac gtattttatt tttatttatg
    31741 tttatatatt tacgtgtgtg tgtgtgtgtg tgtgtgtgta tcacagtact aactaatcta
    31801 ttttttcaca cttcctgcca cctgaccccc taggatggcg tgctcaccat taagctgggc
    31861 ggggatctag ggacctacgt gatcaacaag cagaccccaa acaagcaaat ctggctgtct
    31921 tctccttcca ggtatgttca gaagtcaaaa tccataaggg gtaaactcat ctggaatgcg
    31981 gtgttgggga ccgtttgaga gggagtcagt cactggcttt gccgtgactt tacggctgtc
    32041 tgcctcggca gggaggctgg cttgtagttg aacccttctc ctcattgata cccgggttgc
    32101 tatgcaactc aggcatcagg atgttgacaa gacctgaagc agaaggaact gttcagagcc
    32161 tggcccagac tggttttctc cagtatatca ttccccagaa gagaaaaacc actggcttgc
    32221 ctttgaaaat gatacttttg ccagacacag tcttaacata gctatagtcc cagcactcaa
    32281 gaagtagagg caagaattca aggcctgcct tggctacata gccagttcaa aggctagtct
    32341 gagctatcat gtaagaccct atagcaaaag caaataagca aatctggtcc atatagtgcg
    32401 ttccaggata gccagggcta tccataagcc acttttgtta ggtacagtgg cacatacctg
    32461 cgattaaaaa taataatcat tcattcattc attcattcat taaaaagcta ctttgaggga
    32521 actagagaga tggctcagtt tgctctagaa atcctgagtt catttcccag cagctactta
    32581 gtggctcaca accatctctg atgggatctg atgccctctt ctggtctgtc tgaagagagc
    32641 gatagtgtac tcacatacat acaataaata aatagatctt taaaaaaaaa aaaagctact
    32701 ttgaaggctg agggcatatc tcagtgggag agtgcttatc cagtaatcta taagccctgg
    32761 attcagtttc caaaatggaa aggtaggaag gagaaagagg gaggaatttt ttatattgta
    32821 gtatctgaga aaacttgcac tttgtcctca aagtaagtta aactttaact cctggcctac
    32881 tttgaaggtc tctgtaactc tgctggcaga gctgggctct gactctgtca caacgggacg
    32941 ggacggtgat ttttatcagc agccccaggg cccccagcct catgcctgcc tgccccgtgg
    33001 caatgcctgc agttgaagga gcagcaggat gcactgcagt cagaccctgt ctcagaacta
    33061 aggacttact gataagtata cagctgctgc ctcagtggtc tgggaacagc ctagcgatgc
    33121 ccacagggag ccttcacact aacctccctg aggctcaaca gcagtactga aggagacatt
    33181 ttgaaggagc cgtgggaaat ctcagctaga agcagtgtgg aattctttgg aagcctaatg
    33241 gtattggcag tttttaaaag gtgccaaggt gtggctcagt ggcaaagaac ttgcctagca
    33301 tgtgagagaa ggccctgggt tggaatacca ccacaacaaa cacacagcaa acaaaatggt
    33361 taccactcag gctggagaga tggcttaaga gcccttctgc tccagcacaa gggctagagt
    33421 tcaaatcctg gcatccgtgt cagggtagtc acttacaaga aactccaagg aaactctttt
    33481 taaacccgta attggagctg gagagatggc tcagtggtta agagcactca ccaactcctc
    33541 ttccagagga cccaggttca attcccagca cccacatagc acctcacaac tatctgtaat
    33601 tccaggtcca ggagatctga caccctcaca cagataaata tgcaaacaaa acaccaatgc
    33661 atataaaaca aatacattta aaacctgtaa ttttaggtgc tagagagatg gctgagtggt
    33721 taagagcgct gactgcactt ccaaaggtcc tgaggtcaat ccccagcaac cacatggtgg
    33781 cccacgacca tctataaagg gatctgatgc cctcctctgg tctgcaggta tacttgcaga
    33841 cagagcactc atatatcaaa acaacataaa agcagttaat ttaaaaacca gattatctgt
    33901 tttaaaaact aatgtatatg agaggcttgg gggggcgtct cataagtaac cccgcttcat
    33961 cacaattacg tcataaaggg ggacgggcct ttatatgtct gtgggtgtgg atatggatgt
    34021 ggttgagtgt ccatacctac agtagccagc agagggagcc agatcttctg gagctgtagt
    34081 cacaagcagt tgtaagcagc ccagggtagt gaaagacatc aaaccagtcc tgcggaagag
    34141 cagcaagcgt ccttaaccac tgagccctct ctccatcacc ccggaagtaa tatcatattt
    34201 atccagactg tctttcacag ggccatgatt ataacttctt atttcagaag aaaacctttg
    34261 aggtcctgtg gagacagaat ttcctggccc ccttgccata gaatgtgggg gacgcctggg
    34321 ccccagaatc tgggcgcaga accctggaca atgtggaggg gtcttgagtt gttccaactc
    34381 tacctgagag cagggctgtg gtgcaggatc aaagaacatt ctttggtttc tcctggtttt
    34441 gttttgcttt catgtgaccg gggtactttg tgttcagaga ggtttctgct cttgtaacgg
    34501 aagccctgcc tgtccatttg cccttttctc tgtatgtcca gcatttgatt ggcagtatta
    34561 aaagccctcg tgtatctata cctacacaag atacttccca tctcttccct ctaccctgcc
    34621 ttcccaccac acctcagtct cctcatggtt ttgtgatgct ggagatctaa caatgcggtc
    34681 accacgctgg gaccgctcaa gcactgtgct gctaagctgt gtccccactc ttctagtgtg
    34741 gggttcttcg aaagttccct cgagtgttct cagtggtgaa ctctcagggt tcattgtctg
    34801 ttactgtgtc cactgttctc caggccatga ggagctagaa cgtgagacaa gggtcttata
    34861 catctggaat aacaaatcat ggccaacacc agctaccgat ttgtccgcag taccgtgtat
    34921 tagtcagctt cacatcgcta ccctgaatac ctgagacaag ttaccgataa aagggaaagg
    34981 tttctttatc tcgtggtttt caaggttcag ggtccaagac tgaggaatgc aagggacggc
    35041 tactttagcc tcttatacaa tggtgtaccc tgatgggaga atgtgtagga acaatgtccc
    35101 atcttaggat gggaagcaga gaaagatcag acaggtcccc catttccttt tgtggacaca
    35161 tcgcaatgac cccaggaagt cactcctctt aaaggtagca aaaggaggta gtataaaacc
    35221 gcatcccaaa tgctttctcc tctcacctga agagtggggt agatgcagca acagaacggg
    35281 aaggaagggg acacactgat agagctctca atttcacagc tttaattttc aataaagaaa
    35341 actactttta gctagaaatt atggagcaag ccagtaatcc caacacttga gcgataaagg
    35401 caagaaaatc aagagttcag ggttatcctt ggctatagaa ggaattggag gctagctgag
    35461 gctatgggag accctgtcga aagaagaaag ttttgttttg ttggtttttt gaggcagggt
    35521 cttaacttgt gtgctggctg gttttgtgtg tcaacttgac acaggctgga gttatcacag
    35581 agaaaggagc cttccttgag gaaatgcctc catgagatcc agctgtgagg cattttctca
    35641 attagtgatc aagggggaag ggcctagccc attgtggttg gtgccatccc tgggatggta
    35701 gtcttgggtt ctgtaagaga gcaggctgag caaaccaggg gaagcaagcc agtaaagaac
    35761 atccctccat ggcctctgca tcagcttctg cttcctgacc tgcttgagtt ccagtcctga
    35821 cttcctttgg tgatgaacag cagtatggaa gtgtaagctg aataaaccct ttcctcccca
    35881 acttgctttt tggtcatgat gtttgtgcag gaatacaaac cctcactaag acaccttgga
    35941 tccctggctg gcttggaatt tgctggagag accaagccag cttctgtcca ctaatcgctg
    36001 gaattaaagg cctgtaccac catgcccagc aaagttttta ataatagcac aggtggtagc
    36061 caaggctgga agaggcaagg tagctgatta gtaggtatta gggcttcttt cagggtaata
    36121 ggggtgtttc ggatgtagac agagttagtg gcgacacagt agtgtaggtt gggcattgat
    36181 cagcacatcc gtggtacaaa attagcatca cttcccaaac ctggctgtaa gatagcatct
    36241 gtcctaggaa aaaaagcgat ggaatgaatg tgctgcagag agtttcacgg gggcggggct
    36301 gtggagtgtt ccagaggaca gactgcacag tcagtcgccc tcaggaaggt gctgaggaaa
    36361 gcaaaggctc gcctcactgc gtgtcacgca aagccgcact tggtctctgg gtaccggcag
    36421 ctctggattc cgttagctct tcactgaaag gaggaggcat ttgtttttgg ttcacggtgt
    36481 cagagacttt agttgccgtt gcctttgggc ctacagtgag acagaccatg gccagggaga
    36541 tttgatggag ggaaacagga cggactcccc atcgcccatc caaggcacac tgccagtgac
    36601 ctaacacacc acgtctaggc cttaccagat caagttccca ccccctgcag tagggtcatg
    36661 agctagatcg tgagcttcta accacagctg ccgtgggact tttaagattc agtccagcca
    36721 aatgtggttg ctgataatcc cagcacttag gctgaaacag aagagtgcta caaattgaag
    36781 ggtagccttg gctacacaag tgaggtccag gctacctgtc cggggataca gataggaatc
    36841 tatcttcaaa gacagatcga taagctgggc agtggtggcc atacgctttt agttccagca
    36901 ctcaagaggc agagacaggt ggaactctga gttcaagacc gcctagtcta cagatacagt
    36961 tcaaagacag ccagagctac acagggaaat cctatcttga aaaacaacac aaaagtagat
    37021 agatagataa atagatagat ggatggatag atagatagat gcatgtatgc atgcatacat
    37081 acatacatac tcacacacac agattgattt agtccaaaca cagtggctct cctgaagagg
    37141 atcctcacta acttaccatg aatttgtttt gtctcgcagc ggccccaagc gctatgactg
    37201 gaccgggaag aactgggtgt actctcatga cggcgtgtct ctgcatgagc tgctggccag
    37261 ggagctgact aaagctttaa acaccaaact ggacttgtct tcattggcct attctggaaa
    37321 agg
//
NOR_COMM_FROM_STRING
    end

    should "instantiate" do
      assert_not_nil @nor_comm_from_string
    end

    should "write to PNG returning a Magick::Image" do
      assert_instance_of Magick::Image, @nor_comm_from_string.write_to_file( File.dirname( __FILE__ ) + "/../misc/NorCoMM_from_string_example.png" )
    end
  end
end
