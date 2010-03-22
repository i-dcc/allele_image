require File.dirname(__FILE__) + '/test_helper.rb'

RENDERABLE_FEATURES = {
  "polyA_site" => {
    "SV40 pA" => { "label" => "pA" }
  }
}

module RenderAs
  class PNG
    def render_feature( feature )
      feature
    end
  end
end

class Feature
  attr_reader :type, :name, :start, :stop, :renderer

  def initialize( type, name, start, stop )
    @type, @name, @start, @stop = type, name, start, stop
  end

  def render( format )
    # raise FeatureNotRenderable if RENDERABLE_FEATURES[ self.type ][ self.name ]
    @renderer = eval( "RenderAs::#{ format }.new" )
    @renderer.render_feature( self )
  end
end

class TestFeature < Test::Unit::TestCase
  context "a new Feature" do
    setup do
      @feature = Feature.new( "polyA_site", "SV40 pA", 1000, 2000 )
    end

    should "instintiate" do
      assert_not_nil @feature
      assert_instance_of Feature, @feature
    end

    should "render in given format" do
      assert_not_nil @feature.render( "PNG" )
      assert_instance_of RenderAs::PNG, @feature.renderer
    end
  end
end
