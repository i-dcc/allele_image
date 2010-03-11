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

    # should "return the correct number of features" do
    #   assert_equal 30, @allele_image.features.count
    # end
    # 
    # should "return the correct number of rcmb_primers" do
    #   assert_equal 6, @allele_image.rcmb_primers.count
    # end
    # 
    # should "return the correct number of cassette features" do
    #   # check what the correct number for this file should be and adjust
    #   assert_equal 11, @allele_image.cassette_features.count
    # end
    # 
    # should "return the correct number of 5' arm features" do
    #   assert_equal 6, @allele_image.five_homology_features.count
    # end
    # 
    # should "return the correct number of 3' arm features" do
    #   assert_equal 9, @allele_image.three_homology_features.count
    # end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @allele_image.write_to_file( File.dirname(__FILE__) + "/../misc/allele_image.png" )
    end
  end

  context "a non conditional allele" do
    setup do
      @allele_image = AlleleImage::Image.new( File.dirname( __FILE__ ) + "/../misc/project_47462_non_conditional_allele.gbk" )
    end

    should "instantiate" do
      assert_not_nil @allele_image
    end

    should "render" do
      assert_not_nil @allele_image.render()
    end

    should "write to PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @allele_image.write_to_file( File.dirname( __FILE__ ) + "/../misc/project_47462_non_conditional_allele.png" )
    end
  end
end
