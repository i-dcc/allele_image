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
    @@text_width = 12

    def Feature.text_width(new_width)
      @@text_width = new_width
    end

    attr_reader :feature_type, :feature_name, :orientation, :start, :stop, :render_options

    def initialize( feature_type, feature_name, start, stop, orientation = "forward" )
      unless renderable_feature?( feature_type, feature_name )
        raise "NotRenderable"
      end

      @feature_type = feature_type
      @start, @stop = start, stop
      @orientation  = orientation

      if feature_type == "exon" and not feature_name.match(/En2/)
        @feature_name = feature_name
      else
        @render_options = AlleleImage::RENDERABLE_FEATURES[ feature_type ][ feature_name ]
        @feature_name   = @render_options[ "label" ] || feature_name
      end
    end

    def width
      @render_options and @render_options.has_key?("width") ? @render_options[ "width" ] :  @feature_name.length * @@text_width
    end

    # def render( format )
    #   # raise FeatureNotRenderable if RENDERABLE_FEATURES[ self.feature_type ][ self.feature_name ]
    #   @renderer = eval( "RenderAs::#{ format }.new" )
    #   @renderer.render_feature( self )
    # end

    private
      def renderable_feature?( feature_type, feature_name )
        feature_type == "exon" or \
        ( AlleleImage::RENDERABLE_FEATURES[ feature_type ] and \
          AlleleImage::RENDERABLE_FEATURES[ feature_type ][ feature_name ] )
      end
  end
end
