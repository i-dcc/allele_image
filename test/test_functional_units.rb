require File.dirname(__FILE__) + '/test_helper.rb'

class TestFunctionalUnits < Test::Unit::TestCase
  context "An updated GenBank file" do
    setup do
      @data_dir  = "#{ File.dirname( __FILE__ ) }/../misc/known-issues/functional-units"
      @cassettes = {
        "#{ @data_dir }/157.gbk" => { :label => "L1L2_gt0" }
      }
    end

    should "correctly handle its functional units" do
      @cassettes.each_key do |file|
        allele_image = AlleleImage::Image.new(file)

        assert_not_nil allele_image, "#{ file } has an allele_image"
        assert_equal(
          8,
          allele_image.construct.cassette_features.size,
          "#{ @cassettes[file][:label] } has the correct number of features"
        )
      end
    end
  end
end
