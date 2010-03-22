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
    attr_reader :construct, :input, :input_format, :output_format, :parser, :renderer

    def initialize( input, input_format = "GenBank", output_format = "PNG" )
      @input         = input
      @input_format  = input_format
      @output_format = output_format
      @parser        = AlleleImage::Parser.new( @input, @input_format )
      @construct     = @parser.construct
      @renderer      = AlleleImage::Renderer.new( @construct, @output_format )
    end

    def render
      @renderer.render()
    end

    # def image; end
  end
end