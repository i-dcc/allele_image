module AlleleImage
  # == SYNOPSIS
  #   ai = AlleleImage::Image.new( INPUT ) [ { optional arguments } ]
  #   ai.render() # -> by default this will be a Magick::Image object
  #   ai.image()  # -> same as ai.render()
  #
  # == DESCRIPTION
  # 
  #
  class Image
    attr_reader :construct, :input, :parser, :renderer

    def initialize( input )
      @input         = input
      @parser        = AlleleImage::Parser.new( @input )
      @construct     = @parser.construct
      @renderer      = AlleleImage::Renderer.new( @construct )
    end

    def render_image
      @renderer.image()
    end

    # def image; end
  end
end