require File.dirname(__FILE__) + '/test_helper.rb'

# Expand on these tests
class TestRendererPNG < Test::Unit::TestCase
  context "a PNG renderer" do
    setup do
      @construct = AlleleImage::Construct.new( "features", "circular", "cassette_label" )
      @format    = "PNG"
      @renderer  = AlleleImage::Renderer.new( @construct, @format )
    end

    should "instantiate" do
      assert_not_nil @renderer
      assert_not_nil @renderer.image
    end
  end
end
