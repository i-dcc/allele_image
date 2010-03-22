module AlleleImage
  class Renderer
    attr_reader :image, :renderer

    def initialize( construct, format )
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
