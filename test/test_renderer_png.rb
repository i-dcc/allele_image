require File.dirname(__FILE__) + '/test_helper.rb'

# Expand on these tests
class TestRendererRMagick < Test::Unit::TestCase
  context "a RMagick renderer" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_allele.gbk"
      format     = "GenBank"
      @construct = AlleleImage::Parser.new( file, format ).construct()
      @format    = "RMagick"
      @renderer  = AlleleImage::Renderer.new( @construct, @format )
    end

    should "instantiate" do
      assert_not_nil @renderer
      assert_not_nil @renderer.image
    end
  end
end
