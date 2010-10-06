module AlleleImage
  # TODO:
  # rename this file to constants.rb so we can include the functional
  # units in here as well
  FUNCTIONAL_UNITS = {
    ["En2 intron", "SA", "En2 exon", "Frame 0 insert", "T2A"] => "En2 SA",
    ["En2 intron", "SA", "En2 exon", "Frame 1 insert", "T2A"] => "En2 SA",
    ["En2 intron", "SA", "En2 exon", "Frame 2 insert", "T2A"] => "En2 SA",
    ["En2 intron", "SA", "En2 exon", "Frame k insert", "T2A"] => "En2 SA",
    ["Bact", "neo"] => "Bact::neo"
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
      "Flag" => {},
      "FseI" => {},
      "Frame 0 insert" => {},
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
      "BETA-GEO" => {},
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
      "Frame 2 insert" => {},
      "biotin" => {},
      "TEV" => {},
      "UiPCR cassette" => {},
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
      "Frame 1 insert" => {},
      "pZERO" => {},
      "CD4 TM domain" => {}
    },
    "promoter" => {
      "PGK promoter" => {
        "colour" => "black",
        "label" => "PGK",
        "font" => "white"
      },
      "human ubiquitin promoter" => {},
      "EM7 promoter" => {},
      "human beta actin promoter" => {
        "colour" => "DarkSlateBlue",
        "label" => "Bact",
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
