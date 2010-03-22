module AlleleImage
  # == SYNOPSIS
  #   feature = AlleleImage::Feature.new( type, name, start, stop )
  #   feature.render( FORMAT )
  #
  # == DESCRIPTION
  # A class to represent a feature of interest to us. The feature will
  # only be instantiated if it is one of our RENDERABLE_FEATURES.
  #
  # My thoughts on the AlleleImage::Feature#render( FORMAT ) are not
  # conclusive yet but I think I'm on the right track.
  #
  class Feature
    attr_reader :type, :name, :start, :stop, :renderer

    def initialize( type, name, start, stop )
      # Switch this back on when we have RENDERABLE_FEATURES updated
      # raise "NotRenderable" unless renderable_feature?( type, name )

      @type, @name, @start, @stop = type, name, start, stop
    end

    # def render( format )
    #   # raise FeatureNotRenderable if RENDERABLE_FEATURES[ self.type ][ self.name ]
    #   @renderer = eval( "RenderAs::#{ format }.new" )
    #   @renderer.render_feature( self )
    # end

    private
      def renderable_feature?( type, name )
        return true if type == "exon"
        return false unless AlleleImage::RENDERABLE_FEATURES[ type ]
        return AlleleImage::RENDERABLE_FEATURES[ type ][ name ]
      end
  end
end
