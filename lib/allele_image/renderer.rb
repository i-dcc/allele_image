module AlleleImage
  require "RMagick"
  require "pp"

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
    attr_reader :image

    def initialize( construct, format )
      raise "NotAlleleImageConstruct" unless construct.instance_of?( AlleleImage::Construct )

      @image     = self.render
      @construct = construct
    end

    # The output of this method will get assigned to the @image attribute
    # of the AlleleImage::Renderer class. This is what you get when you
    # call AlleleImage::Image#render_image().
    def render
      image_list = Magick::ImageList.new()

      # render_five_arm( image_list )
      render_cassette( image_list )
      # render_three_arm( image_list )

      image_list.append( false )
    end

    private
      # These methods return a Magick::Image object
      def render_cassette( image_list )
        image_list.new_image(10,10)
      end

      # def render_five_arm( image_list ); image_list.new_image(10,10); end
      # def render_three_arm( image_list ); image_list.new_image(10,10); end
  end
end
