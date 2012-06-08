module AlleleImage
  # TODO:
  # rename this file to constants.rb so we can include the functional
  # units in here as well
  FUNCTIONAL_UNITS = {

    # TODO remove these 3 eventually
    ["En2 intron", "SA", "En2 exon"] => "En2 SA",
    ["En2 intron", "SA", "En2 exon", "Frame K insert"] => "En2 SA (ATG)",
    ["rat Cd4", "TM domain"] => "Cd4 TM",

    ["mouse En2 intron", "Splice Acceptor", "mouse En2 exon"] => "En2 SA",
    ["mouse En2 intron", "Splice Acceptor", "mouse En2 exon", "Frame K insert"] => "En2 SA (ATG)",
    ["rat Cd4", "rat CD4 transmembrane region"] => "Cd4 TM",
    # ["PGK", "DTA", "pA"] => "PGK_DTA_pA",
    # ["pA", "DTA", "PGK"] => "pA_DTA_PGK",
  }

  # IDEALLY THIS WOULD GET PARSED FROM A CONFIG FILE/SCHEMA
  # NOTE THAT THESE ARE ONLY RELEVANT TO THE CASSETTE AS ALL
  # EXONS WILL BE ACCOUNTED FOR
  RENDERABLE_FEATURES = {
    "intron" => {
      "En2 intron" => {}, # TODO remove eventually
      "mouse En2 intron" => {},
      "5' Ifitm2 intron" => {
        #purple
        "colour" => "white",
        "label"  => "Ifitm2 Intron",
        #white
        "font"   => "black",
      },
      "3' Ifitm2 intron" => {
        #purple
        "colour" => "white",
        "label"  => "Ifitm2 Intron",
        #white
        "font"   => "black",
      },
    },
    "primer_bind" => {
      "D5" => {},
      "D3" => {},
      "G5" => {},
      "G3" => {},
      "HD" => {},
      "HU" => {},
      "U5" => {},
      "U3" => {},

      "D5 - recombineering primer" => {},
      "D3 - recombineering primer" => {},
      "G5 - recombineering primer" => {},
      "G3 - recombineering primer" => {},
      "U5 - recombineering primer" => {},
      "U3 - recombineering primer" => {}
    },
    "polyA_site" => {
      "poly A [Split]" => {
        "label" => "pA"
      }
    },
    "misc_feature" => {
      # the functional units
      "En2 SA" => {
        "width" => 80
      },
      "En2 SA (ATG)" => {
        "width" => 80
      },
      "Cd4 TM" => {
        "width"  => 80,
        "colour" => "black",
        "font"   => "white"
      },
      "PGK_DTA_pA" => {
        "width" => 300
      },
      "pA_DTA_PGK" => {
        "width" => 300
      },

      "SV40 pA" => { # TODO remove eventually
        "label" => "pA"
      },
      "SV40 polyadenylation site" => {
        "label" => "pA"
      },
      "PGK pA" => {
        "label" => "pA"
      },
      "BGH pA" => {
        "label" => "pA"
      },
      "delTK1" => {},
      "rat Cd4" => {},
      "Frame K insert" => {},   # will get swallowed by "En2 SA (ATG)"
      "Flag" => {},
      "FseI" => {},
      "pUC ori" => {
        "label" => "ori"
      },
      "PreScission" => {},
      "gap" => {},
      "ECMV IRES" => {
        "colour" => "#f7931e",
        "label" => "IRES",
        "font" => "white"
      },
      "TM domain" => {}, # TODO remove eventually
      "rat CD4 transmembrane region" => {},
      # "osteopontin repeat 2" => {},
      "BETA-GEO" => {
        "colour" => "blue",
        "label" => "lacZ",
        "font" => "white",
        "width" => 140
      },
      "AscI-EagI adpater" => {},
      "3 arm" => {},
      "AttP" => {},
      # "osteopontin repeat 6" => {},
      "target region" => {}, # TODO remove eventually
      "critical region" => {},
      # "osteopontin repeat 1" => {},
      "F3" => {},
      "loxP" => {
        "width" => 40,
        "label" => "loxP"
      },
      "Downstream LoxP" => {
        "width" => 40,
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
      "SA" => {}, # TODO Remove eventually
      "Splice Acceptor" => {},
      "SgrA1" => {},
      "rat CD4 fragment" => {},
      "T2A" => {}, # TODO Remove eventually
      "'self-cleaving' 2A peptide" => {
        'label' => 'T2A'
      },
      "UiPCR" => {},
      "5 arm" => {},
      "Frt" => {
        "width" => 35,
        "label" => "FRT"
      },
      "Rox" => {
        "width" => 35,
        "label" => "Rox",
        "colour" => "pink"
      },
      "Cre" => {
        "width" => 45,
        "label" => "Cre",
        "colour" => "blue"
      },
      "ERT2"=> {},
      "F2A" => {},
      "puromycin N-acetyl transferase" => { "label" => "puro trans" },

      # "osteopontin repeat 4" => {},
      "pZERO" => {},
      "CD4 TM domain" => {},
      "Critical Region" => {},
      "synthetic loxP region" => {},
      "Synthetic Cassette" => {}
    },
    "promoter" => {

      "PGK promoter" => { # TODO Remove eventually
        "colour" => "black",
        "label" => "PGK",
        "font" => "white"
      },
      "mouse phosphoglycerate kinase 1 promoter" => {
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

      # KOMP-Regeneron specific stuff
      "hUBp (human Ubiquitin promoter)" => {
        "colour" => "DarkSlateBlue",
        "label" => "hubiP",
        "font" => "white"
      },
      "hUBC promoter" => {
        "colour" => "DarkSlateBlue",
        "label" => "hubiP",
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
      "rat CD4 B-gal fusion" => {},

      "AmpR" => {},
      "KanR" => {},
      "ccdB/ChlR" => {},
      "ClonNATR" => {},
      "ChlR" => {},
      "ccdB" => {},
      "BsdR" => {},

      "NeoR" => {
        "colour" => "#00a99d",
        "label" => "neo",
        "font" => "white",
        "width" => 80
      },
      "neo" => {
        "colour" => "#00a99d",
        "label" => "neo",
        "font" => "white",
        "width" => 80
      },
      "NeoR*" => {
        "colour" => "#00a99d",
        "label" => "neo*",
        "font" => "white",
        "width" => 80
      },

      "ZeoR" => {},
      "SpecR" => {},
      "DTA" => {
        "colour" => "#ff00ff",
        "label" => "DTA",
        "font" => "white"
      },

      # mirKO
      "pu-Delta-tk" => {},

      "TM-lacZ " => {
        "colour" => "blue",
        "label" => "TM-lacZ",
        "font" => "white",
        "width" => 140
      }
    },

    "exon" => {
      "En2 exon" => {}, # TODO remove eventually
      "mouse En2 exon" => {}
    },

    "intervening sequence" => {
      "intervening sequence" => {}
    },

    # NOTE: 2010-10-28
    # KOMP-Regeneron specific stuff
    # For now we'll just add them as is from the GB files
    # but in the long run we would prefer this follow the
    # same convention as the rest
    "DNA" => {
      "LACZ(for recom.) " => {
        "colour" => "blue",
        "label" => "lacZ",
        "font" => "white",
        "width" => 140
      },
    },
    "misc_recomb" => {
      "loxP (3')" => {
        "label" => "loxP"
      },
      "LoxP (5')" => {
        "label" => "loxP"
      },
      "loxP" => {
        "label" => "loxP"
      }
    },
    "frag" => {
      # "poly A  [Split]" => {
      #   "label" => "pA"
      # },
      "Poly A Signal" => {
        "label" => "pA"
      },
    },
    "polyA_signal" => {
      "SV40 polyA" => {
        "label" => "pA"
      },
      "mPgk polyA" => {
        "label" => "pA"
      },
    }
  }

  RENDERABLE_FEATURES['CDS'] = RENDERABLE_FEATURES['gene']
end
