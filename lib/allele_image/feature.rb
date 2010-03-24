module AlleleImage
  # == SYNOPSIS
  #   feature = AlleleImage::Feature.new( feature_type, feature_name, start, stop )
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
    attr_reader :feature_type, :feature_name, :start, :stop, :renderer

    def initialize( feature_type, feature_name, start, stop )
      # Switch this back on when we have RENDERABLE_FEATURES updated
      raise "NotRenderable" unless renderable_feature?( feature_type, feature_name )

      @feature_type = feature_type
      @start, @stop = start, stop
      @feature_name = AlleleImage::RENDERABLE_FEATURES[ feature_type ][ feature_name ][ "label" ] || feature_name
    end

    # def render( format )
    #   # raise FeatureNotRenderable if RENDERABLE_FEATURES[ self.feature_type ][ self.feature_name ]
    #   @renderer = eval( "RenderAs::#{ format }.new" )
    #   @renderer.render_feature( self )
    # end

    private
      def renderable_feature?( feature_type, feature_name )
        return true if feature_type == "exon"
        return false unless AlleleImage::RENDERABLE_FEATURES[ feature_type ]
        return AlleleImage::RENDERABLE_FEATURES[ feature_type ][ feature_name ]
      end
  end
end
