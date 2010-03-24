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
    attr_reader :construct, :input, :output_format, :parser, :renderer

    def initialize( input )
      @input         = input
      @output_format = output_format
      @parser        = AlleleImage::Parser.new( @input )
      @construct     = @parser.construct
      @renderer      = AlleleImage::Renderer.new( @construct, @output_format )
    end

    def render_image
      @renderer.image()
    end

    # def image; end
  end
end