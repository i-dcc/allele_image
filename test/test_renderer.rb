require 'test_helper'

# Expand on these tests
class TestRendererRMagick < Test::Unit::TestCase
  context "a RMagick renderer" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_allele.gbk"
      @height    = 170
      @width     = 460
      @construct = AlleleImage::Parser.new( file ).construct()
      @renderer  = AlleleImage::Renderer.new( @construct )
    end

    should "instantiate" do
      assert_not_nil @renderer
    end

    should "have a valid image" do
      assert_not_nil @renderer.image
      assert_instance_of Magick::Image, @renderer.image()
    end

    should "have the right dimensions" do
      # assert_equal @width, @renderer.image().columns()
      # assert_equal @height, @renderer.image().rows()
    end

    should "write to GIF file" do
      assert_not_nil @renderer.image.write( File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_allele.gif" )
    end
  end

  context "an empty cassette" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/NorCoMM_project_46776.gbk"
      @height    = 170
      @width     = 460
      @construct = AlleleImage::Parser.new( file ).construct()
      @renderer  = AlleleImage::Renderer.new( @construct )
    end

    should "instantiate" do
      assert_not_nil @renderer
    end

    should "have a valid image" do
      assert_not_nil @renderer.image
      assert_instance_of Magick::Image, @renderer.image()
    end

    should "have the right dimensions" do
      # assert_equal @width, @renderer.image().columns()
      # assert_equal @height, @renderer.image().rows()
    end

    should "write to GIF file" do
      assert_not_nil @renderer.image.write( File.dirname( __FILE__ ) + "/../misc/NorCoMM_project_46776.gif" )
    end
  end

  context "a NorCoMM example" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/norcomm/106140.gbk"
      @construct = AlleleImage::Parser.new( file ).construct()
      @renderer  = AlleleImage::Renderer.new( @construct )
    end

    should "instantiate" do
      assert_not_nil @renderer
    end

    should "have a valid image" do
      assert_not_nil @renderer.image
      assert_instance_of Magick::Image, @renderer.image()
    end

    should "have the right dimensions" do
      # assert_equal @width, @renderer.image().columns()
      # assert_equal @height, @renderer.image().rows()
    end

    should "write to GIF file" do
      assert_not_nil @renderer.image.write( File.dirname( __FILE__ ) + "/../misc/norcomm/106140.gif" )
    end
  end

  context "a Conditional Vector" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_vector.gbk"
      @construct = AlleleImage::Parser.new( file ).construct()
      @renderer  = AlleleImage::Renderer.new( @construct )
    end

    should "instantiate" do
      assert_not_nil @construct
    end

    should "have backbone features" do
      assert_not_nil @construct.backbone_features()
      # pp [ :BACK_BONE_FEATURES => @construct.backbone_features() ]
    end

    should "have no flank features" do
      assert_nil @construct.five_flank_features()
      assert_nil @construct.three_flank_features()
    end

    should "write to GIF file" do
      assert_not_nil @renderer.image.write( File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_vector.gif" )
    end
  end
end
