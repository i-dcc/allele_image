#!/usr/bin/env ruby
module AlleleImage
  # This version draws the cassette @features as boxes whose widths depend on the label length.
  # It inserts gaps in the right places as well.

  # The widths of each feature should be multiplied by a ratio R
  # 
  #   where:
  #   R = image_width / sum_of_feature_widths
  # 
  # This should infact be a CassetteRegion class.
  # The features should be processed in the initialize() method where those
  # of known widths (i.e. FRT, loxP) should get tagged as such. With that in
  # place, when calculating the image width we should use this set width if
  # present. Otherwise we should use the name.length * text_width.
  # 
  # TODO:
  # + Refactor this to separate Rendering from Sorting (move insert_gaps_between() somewhere else)
  # + Currently focussing on the main row only
  class CassetteRegion
    include AlleleImage
    attr_reader :features
    def initialize( features )
      @features              = insert_gaps_between( features )
      @text_width            = 10
      @gap_width             = 5
      @text_height           = 30
      @cassette_width        = calculate_width()
      @cassette_height       = 100
      @sequence_stroke_width = 2.5
      @image                 = Magick::Image.new( @cassette_width, @cassette_height )
    end

    # find sum of feature labels
    def calculate_width
      width, gaps = 0, 0
      @features.each do |feature|
        if feature[:name] == "gap"
          gaps += @gap_width
        # ONLY CONSIDER RENDERABLE FEATURES WHEN CALCULATING WIDTH
        else
          width += feature[:name].length * @text_width # should check/define feature.width/feature[:width] first
        end
      end
      return width + gaps
    end

    # Enough to write "Promoterless Cassette\n(L1L2_gt2)"
    def calculate_height
      @text_height * 2
    end

    # @text_width and @text_height should really be feature_width and feature_height respectively
    def draw_loxp( x, y )
      feature_width = "loxP".length * @text_width
      d = Draw.new
      d.stroke("black")
      d.fill("red")
      d.polygon( x, y, x + feature_width, y + @text_height / 2, x, y + @text_height )
      d.draw( @image )
    end

    # @text_width and @text_height should really be feature_width and feature_height respectively
    def draw_frt( x, y )
      feature_width = "FRT".length * @text_width
      d = Draw.new
      d.stroke("black")
      d.fill("green")
      d.arc( x - feature_width, y, x + feature_width, y + @text_height, 270, 90 )
      d.line( x, y, x, y + @text_height )
      d.draw( @image )
    end

    # draw a box with a label to the correct width
    def draw_cassette_feature( label, x, y, background_colour = "white", text_colour = "black" )
        width  = label.length * @text_width
        height = @text_height

        d = Draw.new

        # create a block
        d.stroke("black")
        d.fill(background_colour)
        d.rectangle( x, y, x + width, y + height )
        d.draw( @image )

        # annotate the block
        d.annotate( @image, width, height, x, y, label ) do
          self.fill        = text_colour
          self.font_weight = BoldWeight
          self.gravity     = CenterGravity
        end
    end

    def render
      cassette_width  = @cassette_width
      cassette_height = @cassette_height                             # again height will need to be calculated
      x               = 0
      y               = ( cassette_height - @text_height ) / 2       # "y" should center the @images vertically

      draw_sequence( x, cassette_height / 2, cassette_width, cassette_height / 2 )

      @features.each do |feature|
        feature_width = 0
        if feature[:name] == "gap"
          feature_width = @gap_width
        else
          draw_feature( feature, x, y )
          feature_width = feature[:name].length * @text_width # or Feature#width if it exists
        end
        x += feature_width # update the x coordinate
      end

      return @image
    end
  end
end
