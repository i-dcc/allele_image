module AlleleImage
  # IDEALLY THIS WOULD GET PARSED FROM A CONFIG FILE
  # NOTE THAT THESE ARE ONLY RELEVANT TO THE CASSETTE
  # AS ALL EXONS WILL BE ACCOUNTED FOR
  RENDERABLE_FEATURES = {
    "SSR_site" => {
      "FRT" => true,
      "loxP" => true
    },
    "polyA_site" => {
      "SV40 pA" => true
    },
    "promoter" => {
      "EM7 promoter" => true,
      "human beta actin promoter" => true,
      "human ubiquitin promoter" => true,
      "PGK Promoter" => true
    },
    "rcmb_primer" => {
      "G5" => true,
      "G3" => true,
      "U5" => true,
      "U3" => true,
      "D5" => true,
      "D3" => true
    },
    "misc_feature" => {}
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