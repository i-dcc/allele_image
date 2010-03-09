require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImage < Test::Unit::TestCase
  context "a new AlleleImage::Image" do
    setup do
      @file = File.dirname(__FILE__) + "/../misc/project_47462_conditional_allele.gbk"
      @allele_image = AlleleImage::Image.new( @file )
    end

    should "instantiate" do
      assert_not_nil @allele_image
    end

    should "return the correct number of features" do
      assert_equal 27, @allele_image.features.count
    end

    should "return the correct number of rcmb_primers" do
      assert_equal 6, @allele_image.rcmb_primers.count
    end

    should "return the correct number of cassette features" do
      # check what the correct number for this file should be and adjust
      assert_equal 14, @allele_image.cassette_features.count
    end

    should "return the correct number of 5' arm features" do
      assert_equal 5, @allele_image.five_homology_features.count
    end

    should "return the correct number of 3' arm features" do
      assert_equal 8, @allele_image.three_homology_features.count
    end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @allele_image.write_to_file( File.dirname(__FILE__) + "/../misc/allele_image.png" )
    end
  end
end
