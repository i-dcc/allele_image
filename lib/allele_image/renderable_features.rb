module AlleleImage
  # IDEALLY THIS WOULD GET PARSED FROM A CONFIG FILE
  # NOTE THAT THESE ARE ONLY RELEVANT TO THE CASSETTE
  # AS ALL EXONS WILL BE ACCOUNTED FOR
  RENDERABLE_FEATURES = {
    "SSR_site" => {
      "FRT" => {},
      "loxP" => {}
    },
    "polyA_site" => {
      "pA" => {}
    },
    "promoter" => {
      "EM7 promoter" => {},
      "Bact::neo" => {
        "label" => "Bact::neo"
      },
      "human ubiquitin promoter" => {},
      "PGK Promoter" => {
        "label" => "PGK"
      }
    },
    "rcmb_primer" => {
      "G5" => {},
      "G3" => {},
      "U5" => {},
      "U3" => {},
      "D5" => {},
      "D3" => {}
    },
    "misc_feature" => {
      "IRES" => {},
      "En2 SA" => {},
      "Bgal" => {},
      "neo" => {}
    }

=begin

ADD THE FOLLOWING AS WE WORK OUT WHAT WE NEED TO RENDER FROM THEM:

    "gateway" => {},
    "gene" => {},
    "LRPCR_primer" => {},
    "intron" => {},
    "primer_bind" => {},
    "PCR_primer" => {},
    "exon" => {}
=end
  }
end