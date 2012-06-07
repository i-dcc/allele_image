module AlleleImage
  class Image
    attr_reader :construct, :input, :parser, :renderer

    def initialize(input, cassetteonly = false)
      @input         = input
      @parser        = AlleleImage::Parser.new( @input )
      @construct     = @parser.construct
      @renderer      = AlleleImage::Renderer.new( @construct, :cassetteonly => cassetteonly )
    end

    def render
      @renderer.image
    end
  end
end
