module AlleleImage
  # IDEALLY THIS WOULD GET PARSED FROM A CONFIG FILE/SCHEMA
  # NOTE THAT THESE ARE ONLY RELEVANT TO THE CASSETTE AS ALL
  # EXONS WILL BE ACCOUNTED FOR
  RENDERABLE_FEATURES = {
            "SSR_site" => {
                            "FRT site" => { "label" => "FRT" },
                            "loxP" => { "label" => "loxP" },
                            "loxP site" => { "label" => "loxP" },
                            "FRT" => { "label" => "FRT" }
                          },
            "polyA_site" => {
                              "SV40 pA" => { "label" => "pA" }
                            },
            "misc_feature" => {
                                "EN2_exon2" => { "label" => false },
                                "neoSphI_5 seq primer" => { "label" => false },
                                "loxp site" => { "label" => "loxP" },
                                "IRES5for seq primer" => { "label" => false },
                                "LoxP" => { "label" => "loxP" },
                                "osteopontin repeat 2" => { "label" => false },
                                "lacZ" => { "label" => "Bgal" },
                                "FCHK2 seq primer" => { "label" => false },
                                "EM7_3'" => { "label" => false },
                                "osteopontin repeat 6" => { "label" => false },
                                "frame 0" => { "label" => false },
                                "neomycin resistance " => { "label" => "neo", "colour" => "aquamarine", "font" => "white" },
                                "FRT" => { "label" => "FRT" },
                                "Gateway L1 site" => { "label" => false },
                                "osteopontin repeat 1" => { "label" => false },
                                "FRT " => { "label" => "FRT" },
                                "En2_exon2" => { "label" => false },
                                "neo" => { "label" => "neo" },
                                "B1 site" => { "label" => false },
                                "L1 seq primer" => { "label" => false },
                                "bgal" => { "label" => "Bgal" },
                                "LRPCR RAF5" => { "label" => false },
                                "EM7_3' seq primer" => { "label" => false },
                                "en-2 intron" => { "label" => "En2 SA" },
                                "PNF seq primer" => { "label" => false },
                                "3IRES5" => { "label" => false },
                                "neoPstI_5 seq primer" => { "label" => false },
                                "Gateway L1" => { "label" => false },
                                "loxP site" => { "label" => "loxP" },
                                "EM7" => { "label" => false },
                                "B2 site?" => { "label" => false },
                                "FRT3" => { "label" => false },
                                "seq primer NF" => { "label" => false },
                                "betact5" => { "label" => false },
                                "seq primer FCHK1" => { "label" => false },
                                "osteopontin repeat 3" => { "label" => false },
                                "GatewayL2" => { "label" => false },
                                "osteopontin repeat 4" => { "label" => false },
                                "Frt" => { "label" => false },
                                "seq primer FCHK2" => { "label" => false },
                                "En2 intron" => { "label" => "En2 SA" },
                                "rat Cd4" => { "label" => false },
                                "en2intronbound3" => { "label" => false },
                                "LacZCla5" => { "label" => false },
                                "seq primer L1" => { "label" => false },
                                "neo ORF" => { "label" => false },
                                "FRT5" => { "label" => false },
                                "neoBstB1_5 seq primer" => { "label" => false },
                                "En2SAF" => { "label" => false },
                                "ECMV IRES" => { "label" => "IRES" },
                                "en2intronbound3 seq primer" => { "label" => false },
                                "TM domain" => { "label" => false },
                                "PGK Promoter" => { "label" => "PGK" },
                                # "en-2 exon" => { "label" => false },
                                "FRT site" => { "label" => "FRT" },
                                "neoPstI_5" => { "label" => false },
                                "3IRES5 seq primer" => { "label" => false },
                                "SV40 pA" => { "label" => "pA" },
                                "LAR3_1" => { "label" => false },
                                "osteopontin repeat 5" => { "label" => false },
                                "neoBstB1_5" => { "label" => false },
                                "Gateway L2 site" => { "label" => false },
                                "loxP" => { "label" => "loxP" },
                                "Gateway L2" => { "label" => false },
                                "neoSphI_5" => { "label" => false },
                                "En2 exon" => { "label" => false },
                                "LRPCR LAR3_EN2" => { "label" => false },
                                "frame2" => { "label" => false },
                                "EM7 promoter" => { "label" => false },
                                "IRES5for primer" => { "label" => false },
                                "LacZCla5 seq primer" => { "label" => false },
                                "ClonNAT" => { "label" => false },
                                "frame 1" => { "label" => false },
                                "frame1" => { "label" => false },
                                "frame0" => { "label" => false },
                                "rat CD4 fragment" => { "label" => false },
                                "betact5 seq primer" => { "label" => false },
                                "NF seq primer" => { "label" => false },
                                "T2A" => { "label" => false },
                                "frame 2" => { "label" => false },
                                "FCHK2" => { "label" => false },
                                "RAF5" => { "label" => false },
                                "human beta actin promoter" => { "label" => "Bact::neo" },
                                "CD4 TM domain" => { "label" => false },
                                "b-galactosidase" => { "label" => "Bgal" },
                                "Gateway  L1 site" => { "label" => false }
                              },
            "intron" => {
                          "En2 intron1" => { "label" => "En2 SA" }
                        },
            "promoter" => {
                            "human ubiquitin promoter" => { "label" => false },
                            "EM7 promoter" => { "label" => false },
                            "PGK Promoter" => { "label" => "PGK" },
                            "human beta actin promoter" => { "label" => "Bact::neo" }
                          },
            "rcmb_primer" => {
                                  "G5" => {},
                                  "G3" => {},
                                  "U5" => {},
                                  "U3" => {},
                                  "D5" => {},
                                  "D3" => {}
                                },
                                "genomic" => {
                                  "5 arm" => {},
                                  # "target region" => {}, since we don't render it
                                  "3 arm" => {}
            }
            # THESE STILL NEED TO BE VERIFIED:
            # "PCR_primer" => {
            #                   "EN2FRT 5'LRPCR" => { "label" => false }
            #                 },
            # "primer_bind" => {
            #                    "seq primer L1" => { "label" => false },
            #                    "R2 primer" => { "label" => false },
            #                    "L1 seq primer" => { "label" => false },
            #                    "FRT5" => { "label" => false },
            #                    "R2R primer" => { "label" => false },
            #                    "PNF seq primer" => { "label" => false },
            #                    "IRES5for primer" => { "label" => false },
            #                    "FRT5 seq primer" => { "label" => false },
            #                    "FRT3" => { "label" => false },
            #                    "seq primer NF" => { "label" => false },
            #                    "NF seq primer" => { "label" => false },
            #                    "FCHK2" => { "label" => false },
            #                    "FCHK2 seq primer" => { "label" => false },
            #                    "R1 primer" => { "label" => false },
            #                    "seq primer FCHK1" => { "label" => false },
            #                    "FCHK1 seq primer" => { "label" => false },
            #                    "seq primer FCHK2" => { "label" => false },
            #                    "seq primer PNF" => { "label" => false },
            #                    "FRT3 seq primer" => { "label" => false },
            #                    "R1R primer" => { "label" => false }
            #                  },
            # "gateway" => {
            #                "Gateway R1" => { "label" => false },
            #                "B1" => { "label" => false },
            #                "Gateway L2 site" => { "label" => false },
            #                "Gateway L1 site" => { "label" => false },
            #                "Gateway R2" => { "label" => false },
            #                "B2" => { "label" => false },
            #                "Gateway L1" => { "label" => false },
            #                "Gateway L2" => { "label" => false },
            #                "Gateway  L1 site" => { "label" => false }
            #              },
            # "gene" => {
            #             "neo" => { "label" => false },
            #             "En2 T2A fusion" => { "label" => false },
            #             "neo translation" => { "label" => false },
            #             "b-galactosidase" => { "label" => false },
            #             "bgal" => { "label" => false },
            #             "rat CD4 B-gal fusion" => { "label" => false },
            #             "B gal translation" => { "label" => false }
            #           },
            # "LRPCR_primer" => {
            #                     "LRPCR LAR3_EN2" => { "label" => false },
            #                     "RAF5" => { "label" => false },
            #                     "LRPCR RAF5" => { "label" => false },
            #                     "LAR3_1" => { "label" => false }
            #                   },
            # "CDS" => {
            #            "neo ORF" => { "label" => false }
            #          },
            # "exon" => {
            #             "En2_exon2" => { "label" => false },
            #             "EN2_exon2" => { "label" => false }
            #           }
  }
end
