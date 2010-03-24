require File.dirname(__FILE__) + '/test_helper.rb'

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

    should "write to PNG file" do
      assert_not_nil @renderer.image.write( File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_allele.png" )
    end
  end
end
