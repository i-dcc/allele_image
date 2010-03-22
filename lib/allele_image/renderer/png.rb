module AlleleImage
  # == SYNOPSIS
  #   image = AlleleImage::Renderer.new( CONSTRUCT, FORMAT )
  #
  # == DESCRIPTION
  # This expects you to implement a renderer for FORMAT that inherits
  # from AlleleImage::Renderer and implements a render() method. This method
  # MUST accept an AlleleImage::Construct object which gets passed to your
  # AlleleImage::Renderer::FORMAT#render() method. The render() should return
  # something (not nil) that gets assigned to the AlleleImage::Renderer@image
  # attribute.
  #
  # == NOTE
  # You can get at the image via the @image attribute directly or from the
  # render() method. So it's up to you to make sure it is what you expect.
  #
  class Renderer
    attr_reader :image, :renderer

    def initialize( construct, format )
      raise "NotAlleleImageConstruct" unless construct.instance_of?( AlleleImage::Construct )

      @renderer = eval "AlleleImage::Renderer::#{ format }.new()"
      @image    = @renderer.render( construct )
    end

    class PNG < Renderer
      def initialize; end

      def render( construct )
        construct
      end
    end
  end
end
