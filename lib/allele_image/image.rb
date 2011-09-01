module AlleleImage
  class Image
    attr_reader :construct, :input, :parser, :renderer

    def initialize(input)
      @input         = input
      @parser        = AlleleImage::Parser.new( @input )
      @construct     = @parser.construct
      @renderer      = AlleleImage::Renderer.new( @construct )
    end

    def render
      @renderer.image
    end
  end
end
