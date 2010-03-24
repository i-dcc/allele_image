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

    def initialize( construct )
      raise "NotAlleleImageConstruct" unless construct.instance_of?( AlleleImage::Construct )

      @construct   = construct

      @gap_width   = 10
      @text_width  = 10
      @text_height = 10

      @image = self.render
    end

    # The output of this method will get assigned to the @image attribute
    # of the AlleleImage::Renderer class. This is what you get when you
    # call AlleleImage::Image#render_image().
    def render
      image_list = Magick::ImageList.new()

      # render_five_arm( image_list )
      image_list.push( render_cassette() )
      # render_three_arm( image_list )

      image_list.append( false )
    end

    private
      # These methods return a Magick::Image object
      def render_cassette
        cassette_features = insert_gaps_between( @construct.cassette_features() )
        cassette_width    = calculate_width( cassette_features )
        cassette_height   = 100 # again height will need to be calculated
        image             = Magick::Image.new( cassette_width, cassette_height )
        x                 = 0
        y                 = ( cassette_height - @text_height ) / 2 # "y" should center the images vertically

        # draw_sequence( x, cassette_height / 2, cassette_width, cassette_height / 2 )

        cassette_features.each do |feature|
          feature_width = 0
          if feature.feature_name() == "gap"
            feature_width = @gap_width
          else
            # draw_feature( feature, x, y )
            draw_cassette_feature( image, feature, x, y )
            feature_width = feature.feature_name().length * @text_width # or Feature#width if it exists
          end
          x += feature_width # update the x coordinate
        end

        # unless @cassette_label.nil?
        #   label_image = Magick::Image.new( self.calculate_width, self.calculate_height )
        #   draw_label( @cassette_label, label_image, 0, 0 )
        #   image = Magick::ImageList.new.push( image ).push( label_image ).append( true )
        # end

        return image
      end

      # def render_five_arm; image_list.new_image(10,10); end
      # def render_three_arm; image_list.new_image(10,10); end

      # DRAW METHODS
      # draw a box with a label to the correct width
      def draw_cassette_feature( image, feature, x, y, background_colour = "white", text_colour = "black" )
          width  = feature.feature_name().length * @text_width
          height = @text_height
          d      = Magick::Draw.new

          # create a block
          d.stroke( "black" )
          d.fill( background_colour )
          d.rectangle( x, y, x + width, y + height )
          d.draw( image )

          # annotate the block
          d.annotate( image, width, height, x, y, feature.feature_name() ) do
            self.fill        = text_colour
            self.font_weight = Magick::BoldWeight
            self.gravity     = Magick::CenterGravity
          end
      end

      # UTILITY METHODS
      # find sum of feature labels
      def calculate_width( features )
        width, gaps = 0, 0
        features.each do |feature|
          if feature.feature_name() == "gap"
            gaps += @gap_width
          else
            width += feature.feature_name().length * @text_width # should check/define feature.width/feature[:width] first
          end
        end
        # # This will "fix" the NorCoMM allelles but it does throw off the boundries
        # # of the cassette region, so we will ignore this for now
        # unless @cassette_label.nil?
        # return [ width + gaps, @cassette_label.length * @text_width ].max
        # end
        return width + gaps
      end

      # decide on the need for a gap/space. we need one:
      # + after each SSR_site unless its the last feature in the cassette region
      # + before each SSR_site unless its the first feature in the cassette region
      def insert_gaps_between( features )
        features_with_gaps = []
        gap_feature        = AlleleImage::Feature.new( "misc_feature", "gap", 1, 1 )
        previous_feature   = nil

        return features_with_gaps unless features

        features.each do |feature|
          unless previous_feature.nil?
            case [ previous_feature.feature_type(), feature.feature_type() ]
            # need a way to say [ "SSR_site", "whatever" ]
            when [ "SSR_site", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "SSR_site", "misc_feature" ]
              features_with_gaps.push( gap_feature )
            when [ "SSR_site", "polyA_site" ]
              features_with_gaps.push( gap_feature )
            when [ "SSR_site", "promoter" ]
              features_with_gaps.push( gap_feature )
            when [ "misc_feature", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "polyA_site", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "promoter", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "exon", "exon" ]
              features_with_gaps.push( gap_feature )
            when [ "exon", "intervening sequence" ]
              features_with_gaps.push( gap_feature )
            when [ "intervening sequence", "exon" ]
              features_with_gaps.push( gap_feature )
            else
              # do nothing
            end
          end

          features_with_gaps.push( feature )
          previous_feature = feature
        end

        return features_with_gaps
      end
  end
end

=begin From branch master:

      # Enough to write "Promoterless Cassette\n(L1L2_gt2)"
      def calculate_height
        @text_height * 2
      end
=end
