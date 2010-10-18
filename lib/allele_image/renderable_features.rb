module AlleleImage
  # TODO:
  # rename this file to constants.rb so we can include the functional
  # units in here as well
  FUNCTIONAL_UNITS = {
    ["En2 intron", "SA", "En2 exon"] => "En2 SA",
    ["En2 intron", "SA", "En2 exon", "Frame K insert"] => "En2 SA (ATG)",
    ["rat Cd4", "TM domain"] => "rat Cd4 TM",
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
      "En2 SA" => {
        "width" => 80
      },
      "En2 SA (ATG)" => {
        # "label" => "En2 SA",
        # "width" => 80
        # "annotation" => [{"text" => "En2 SA", "location" => "centre"
        # }, { "text" => "ATG", "location" => "above/top/north" }]
      },
      "rat Cd4 TM" => {},

      "Frame K insert" => {},   # will get swallowed by "En2 SA (ATG)"
      "Flag" => {},
      "FseI" => {},
      "pUC ori" => {
        "label" => "ori"
      },
      "PreScission" => {},
      "gap" => {},
      "ECMV IRES" => {
        "colour" => "orange",
        "label" => "IRES",
        "font" => "white"
      },
      "TM domain" => {},
      "osteopontin repeat 2" => {},
      "BETA-GEO" => {
        "colour" => "blue",
        "label" => "lacZ",
        "font" => "white",
        "width" => 140
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
    },
    "gene" => {
      "Puro" => {
        "colour" => "purple",
        "label" => "Puro",
        "font" => "white",
        "width" => 80
      },
      "PheS" => {},
      "lacZ" => {
        "colour" => "blue",
        "label" => "lacZ",
        "font" => "white",
        "width" => 140
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
        "colour" => "aquamarine",
        "label" => "neo",
        "font" => "white",
        "width" => 80
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
