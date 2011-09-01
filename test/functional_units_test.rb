require 'test_helper'

class TestFunctionalUnits < AlleleImage::TestCase
  context "An updated GenBank file" do
    setup do
      @data_dir  = "#{TEST_ROOT}/../misc/known-issues/functional-units"
      @cassettes = {
        # list should include an example from every cassette. missing include:
        # - L1L2_Bact_EM7
        # - L1L2_hubi_P
        "#{ @data_dir }/157.gbk"   => {
          :label => "L1L2_gt0",
          :expected_features =>
            ["FRT", "En2 SA", "T2A", "lacZ", "T2A", "neo", "pA", "FRT", "loxP"]
        },
        "#{ @data_dir }/27498.gbk" => {
          :label => "L1L2_GOHANU",
          :expected_features =>
            ["F3", "UiPCR", "SA", "IRES", "lacZ", "pA", "loxP", "hBactP",
             "delTK1", "T2A", "neo", "pA", "loxP", "AttP", "Puro", "pA", "FRT"]
        },
        "#{ @data_dir }/27415.gbk" => {
          :label => "L1L2_NTARU-0",
          :expected_features =>
            ["F3", "UiPCR", "En2 SA", "T2A", "lacZ", "T2A", "neo", "pA", "AttP", "Puro", "pA", "FRT"]
        },
        "#{ @data_dir }/27437.gbk" => {
          :label => "L1L2_NTARU-1",
          :expected_features =>
            ["F3", "UiPCR", "En2 SA", "T2A", "lacZ", "T2A", "neo", "pA", "AttP", "Puro", "pA", "FRT"]
        },
        "#{ @data_dir }/27433.gbk" => {
          :label => "L1L2_NTARU-2",
          :expected_features =>
            ["F3", "UiPCR", "En2 SA", "T2A", "lacZ", "T2A", "neo", "pA", "AttP", "Puro", "pA", "FRT"]
        },
        "#{ @data_dir }/27474.gbk" => {
          :label => "L1L2_NTARU-K",
          :expected_features =>
            ["F3", "UiPCR", "En2 SA (ATG)", "lacZ", "T2A", "neo", "pA", "AttP", "Puro", "pA", "FRT"]
        },
        "#{ @data_dir }/910.gbk" => {
          :label => "L1L2_st0",
          :expected_features =>
            ["FRT", "En2 SA", "Cd4 TM", "lacZ", "T2A", "neo", "pA", "FRT", "loxP"]
        },
        # TODO: this demonstrates that the promoters _are not_ quite
        # done yet as the arrow in the backbone should be pointing
        # towards the *DTA* feature not the *SpecR* feature
        "#{ @data_dir }/152.gbk" => {
          :label => "L1L2_Pgk_P",
          :expected_features =>
            ["FRT", "En2 SA", "IRES", "lacZ", "pA", "loxP", "PGK", "neo", "pA", "FRT", "loxP"]
        },
        "#{ @data_dir }/1056.gbk" => {
          :label => "L1L2_Pgk_PM",
          :expected_features =>
            ["FRT", "En2 SA", "IRES", "lacZ", "pA", "loxP", "PGK", "neo*", "pA", "FRT", "loxP"]
        },
        "#{ @data_dir }/2935.gbk" => {
          :label => "L1L2_gtk",
          :expected_features =>
            ["FRT", "En2 SA (ATG)", "T2A", "lacZ", "T2A", "neo", "pA", "FRT", "loxP"]
        },
      }
      @backbones = {
        "#{ @data_dir }/144.gbk" => {
          :label => "L3L4_pD223_DTA_spec",
          :expected_features => ["AsiSI", "ori", "SpecR", "PGK", "DTA", "pA"]
        },
      }
    end

    should "correctly handle its functional units" do
      @cassettes.each_key do |file|
        allele_image = AlleleImage::Image.new(file)
        allele_image.render.write( file.gsub( /\.gbk$/, ".png" ) )
        assert_not_nil allele_image, "#{ file } has an allele_image"

        all_features = allele_image.construct.cassette_features.map { |feature| feature.feature_name }
        cassette_features = @cassettes[file][:expected_features]
        assert((cassette_features - all_features).empty?,
          "#{ @cassettes[file][:label] } has the correct features: #{(cassette_features - all_features)}")
      end

      @backbones.each_key do |file|
        allele_image = AlleleImage::Image.new(file)
        allele_image.render.write( file.gsub( /\.gbk$/, ".png" ) )
        assert_not_nil allele_image, "#{ file } has an allele_image"
        assert_equal(
          @backbones[file][:expected_features],
          allele_image.construct.backbone_features.map { |feature| feature.feature_name },
          "#{ @backbones[file][:label] } has the correct features"
        )
      end
    end
  end
end
