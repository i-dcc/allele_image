module AlleleImage

  # IDEALLY THIS WOULD GET PARSED FROM A CONFIG FILE/SCHEMA
  # NOTE THAT THESE ARE ONLY RELEVANT TO THE CASSETTE AS ALL
  # EXONS WILL BE ACCOUNTED FOR
  RENDERABLE_FEATURES = {
    "intervening sequence" => {
      "intervening sequence" => {}
    },
    "polyA_site" => {
      "SV40 pA" => {
        "label" => "pA"
      },
      "BGH pA" => {
        "label" => "pA"
      },
      "PGK pA" => {
        "label" => "pA"
      }
    },
    "misc_feature" => {
      "5 arm" => {},
      "target region" => {},
      "3 arm" => {},
      "gap" => {},
      # do we want to display the UiPCR elements?
      "UiPCR cassette" => {},
      "UiPCR" => {},
      "BETA-GEO" => {},
      "Flag" => {},
      "FseI" => {},
      "pUC ori" => {
        "label" => "ori"
      },
      "Frame 0 insert" => {},
      "Transcription Terminator" => {},
      "PreScission" => {},
      "FRAME INSERT. Has ATG init codon, but no T2A" => {},
      "pBR322" => {},
      "ECMV IRES" => {
        "label"  => "IRES",
        "colour" => "orange",
        "font"   => "white"
      },
      "TM domain" => {},
      "osteopontin repeat 2" => {},
      "AscI-EagI adpater" => {},
      "osteopontin repeat 6" => {},
      "AttP" => {},
      "LAR3_1" => {},
      "osteopontin repeat 1" => {},
      "En2 SA" => {},
      "loxP" => {
        "label" => "loxP",
        "width" => 35
      },
      "F3" => {},
      "Frame 2 insert" => {},
      "biotin" => {},
      "TEV" => {},
      "Ty1" => {},
      "ChlR_ccdB" => {},
      "SA (En2)" => {},
      "ipcrTAR1 (GH1111)" => {},
      "AsiSI" => {},
      "EGFP" => {},
      "SA" => {},
      "ATG initiation codon" => {},
      "SgrA1" => {},
      "rat CD4 fragment" => {},
      "T2A" => {},
      "osteopontin repeat 4" => {},
      "Frt" => {
        "label" => "FRT",
        "width" => 35
      },
      "pZERO" => {},
      "Frame 1 insert" => {},
      "CD4 TM domain" => {},
      "neomycin resistance fragment cloned into L1L2Betabackbone" => {}
    },
    "gene" => {
      "Puro" => {
        "label"  => "Puro",
        "colour" => "purple",
        "font"   => "white"
      },
      "PheS" => {},
      "En2 T2A fusion" => {},
      "rat CD4 B-gal fusion" => {},
      "lacZ" => {
        "label"  => "lacZ",
        "colour" => "blue",
        "font"   => "white"
      }
    },
    "CDS" => {
      "AmpR" => {},
      "ccdB/ChlR" => {},
      "KanR" => {},
      "BsdR" => {},
      "ccdB" => {},
      "ChlR" => {},
      "ClonNATR" => {},
      "NeoR" => {
        "label"  => "neo",
        "colour" => "DarkSlateBlue",
        "font"   => "white"
      },
      "ZeoR" => {},
      "spectinomycin R short (aadA1) ORF" => {},
      "SpecR" => {},
      "DTA" => {
        "label"  => "DTA",
        "colour" => "violet",
        "font"   => "white"
      }
    },
    "intron" => {
      "En2 intron" => {}
    },
    "primer_bind" => {
      "G5" => {},
      "G3" => {},
      "U5" => {},
      "U3" => {},
      "D5" => {},
      "D3" => {}
    },
    "promoter" => {
      "PGK promoter" => {
        "label"  => "PGK",
        "colour" => "black",
        "font"   => "white"
      },
      "human ubiquitin promoter" => {},
      "EM7 promoter" => {},
      "human beta actin promoter" => {
        "label"  => "Bact",
        "colour" => "DarkSlateBlue",
        "font"   => "white"
      },
      "spectinomycin promoter" => {}
    },
    "exon" => {
      "En2 exon" => {}
    }
  }
end
