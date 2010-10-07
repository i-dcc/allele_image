require File.dirname(__FILE__) + '/test_helper.rb'

class TestFunctionalUnits < Test::Unit::TestCase
  context "An updated GenBank file" do
    setup do
      @data_dir  = "#{ File.dirname( __FILE__ ) }/../misc/known-issues/functional-units"
      @cassettes = {
        # list should include an example from every cassette
        "#{ @data_dir }/157.gbk"   => {
          :label => "L1L2_gt0",
          :expected_features =>
            ["FRT", "En2 SA", "T2A", "lacZ", "T2A", "neo", "pA", "FRT", "loxP"]
        },
        "#{ @data_dir }/6133.gbk"  => {
          :label => "L1L2_Bact_EM7",
          :expected_features =>
            ["FRT", "En2 SA", "IRES", "lacZ", "pA", "loxP", "hBactP", "neo", "pA", "FRT", "loxP"]
        },
        "#{ @data_dir }/25075.gbk" => {
          :label => "L1L2_hubi_P",
          :expected_features =>
            ["FRT", "En2 SA", "IRES", "lacZ", "pA", "loxP", "hubiP", "neo", "pA", "FRT", "loxP"]
        },
        "#{ @data_dir }/27498.gbk" => {
          :label => "L1L2_GOHANU",
          :expected_features =>
            # TODO: add an "F3" in the GB file and update this list
            ["UiPCR", "SA", "IRES", "lacZ", "pA", "loxP", "hBactP",
              "T2A", "neo", "pA", "loxP", "AttP", "Puro", "pA", "FRT"]
        }
      }
    end

    should "correctly handle its functional units" do
      @cassettes.each_key do |file|
        allele_image = AlleleImage::Image.new(file)

        assert_not_nil allele_image, "#{ file } has an allele_image"
        assert_equal(
          @cassettes[file][:expected_features],
          allele_image.construct.cassette_features.map { |feature| feature.feature_name },
          "#{ @cassettes[file][:label] } has the correct features"
        )
      end
    end
  end
end
