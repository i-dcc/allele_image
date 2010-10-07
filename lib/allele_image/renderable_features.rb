module AlleleImage
  # TODO:
  # rename this file to constants.rb so we can include the functional
  # units in here as well
  FUNCTIONAL_UNITS = {
    ["En2 intron", "SA", "En2 exon"] => "En2 SA",
    ["En2 intron", "SA", "En2 exon", "ATG initiation codon"] => "En2 SA (ATG)",
  }

  # IDEALLY THIS WOULD GET PARSED FROM A CONFIG FILE/SCHEMA
  # NOTE THAT THESE ARE ONLY RELEVANT TO THE CASSETTE AS ALL
  # EXONS WILL BE ACCOUNTED FOR
  RENDERABLE_FEATURES = {
    "intron" => {
      "En2 intron" => {}
    },
    "primer_bind" => {
      "D5" => {},
      "D3" => {},
      "G5" => {},
      "G3" => {},
      "U5" => {},
      "U3" => {}
    },
    "polyA_site" => {
      "SV40 pA" => {
        "label" => "pA"
      },
      "PGK pA" => {
        "label" => "pA"
      },
      "BGH pA" => {
        "label" => "pA"
      }
    },
    "misc_feature" => {
      # the functional units
      "En2 SA" => {},

      "Flag" => {},
      "FseI" => {},
      "pUC ori" => {
        "label" => "ori"
      },
      "Transcription Terminator" => {},
      "PreScission" => {},
      "gap" => {},
      "ECMV IRES" => {
        "colour" => "orange",
        "label" => "IRES",
        "font" => "white"
      },
      "pBR322" => {},
      "TM domain" => {},
      "osteopontin repeat 2" => {},
      "BETA-GEO" => {
        "colour" => "blue",
        "label" => "lacZ",
        "font" => "white"
      },
      "AscI-EagI adpater" => {},
      "3 arm" => {},
      "AttP" => {},
      "osteopontin repeat 6" => {},
      "target region" => {},
      "osteopontin repeat 1" => {},
      "F3" => {},
      "loxP" => {
        "width" => 35,
        "label" => "loxP"
      },
      "biotin" => {},
      "TEV" => {},
      "UiPCR cassette" => {
        "label" => "UiPCR"
      },
      "Ty1" => {},
      "ChlR_ccdB" => {},
      "ipcrTAR1 (GH1111)" => {},
      "EGFP" => {},
      "AsiSI" => {},
      "SA" => {},
      "SgrA1" => {},
      "rat CD4 fragment" => {},
      "T2A" => {},
      "UiPCR" => {},
      "5 arm" => {},
      "Frt" => {
        "width" => 35,
        "label" => "FRT"
      },
      "osteopontin repeat 4" => {},
      "pZERO" => {},
      "CD4 TM domain" => {}
    },
    "promoter" => {
      "PGK promoter" => {
        "colour" => "black",
        "label" => "PGK",
        "font" => "white"
      },
      "human ubiquitin promoter" => {
        "colour" => "DarkSlateBlue",
        "label" => "hubiP",
        "font" => "white"
      },
      "human beta actin promoter" => {
        "colour" => "DarkSlateBlue",
        "label" => "hBactP",
        "font" => "white"
      },
      "spectinomycin promoter" => {}
    },
    "gene" => {
      "Puro" => {
        "colour" => "purple",
        "label" => "Puro",
        "font" => "white"
      },
      "PheS" => {},
      "lacZ" => {
        "colour" => "blue",
        "label" => "lacZ",
        "font" => "white"
      },
      "rat CD4 B-gal fusion" => {}
    },
    "exon" => {
      "En2 exon" => {}
    },
    "CDS" => {
      "AmpR" => {},
      "KanR" => {},
      "ccdB/ChlR" => {},
      "ClonNATR" => {},
      "ChlR" => {},
      "ccdB" => {},
      "BsdR" => {},
      "NeoR" => {
        "colour" => "DarkSlateBlue",
        "label" => "neo",
        "font" => "white"
      },
      "ZeoR" => {},
      "SpecR" => {},
      "DTA" => {
        "colour" => "violet",
        "label" => "DTA",
        "font" => "white"
      }
    },
    "intervening sequence" => {
      "intervening sequence" => {}
    }
  }
end
