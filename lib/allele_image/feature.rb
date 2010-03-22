# RENDERABLE_FEATURES = {
#   "polyA_site" => {
#     "SV40 pA" => { "label" => "pA" }
#   }
# }
# 
# module RenderAs
#   class PNG
#     def render_feature( feature )
#       feature
#     end
#   end
# end

module AlleleImage
  # == SYNOPSIS
  #   feature = AlleleImage::Feature.new( type, name, start, stop )
  #   feature.render( FORMAT )
  #
  # == DESCRIPTION
  #
  class Feature
    attr_reader :type, :name, :start, :stop, :renderer

    def initialize( type, name, start, stop )
      @type, @name, @start, @stop = type, name, start, stop
    end

    # def render( format )
    #   # raise FeatureNotRenderable if RENDERABLE_FEATURES[ self.type ][ self.name ]
    #   @renderer = eval( "RenderAs::#{ format }.new" )
    #   @renderer.render_feature( self )
    # end
  end
end
