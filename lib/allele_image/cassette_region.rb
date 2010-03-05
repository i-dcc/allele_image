#!/usr/bin/env ruby
module AlleleImage
  # This version draws the cassette @features as boxes whose widths depend on the label length.
  # It inserts gaps in the right places as well.

  # class Feature
  #   attr_reader :type, :start, :stop, :label
  #   
  #   def initialize(type, start, stop, label)
  #     @type, @start, @stop, @label = type, start, stop, label
  #   end
  #  
  #   def render(format, params={})
  #     format.new(self).render_feature(params)
  #   end
  #  
  #   def to_hash
  #     { :type => @type, :label => @label, :start => @start, :stop => @stop }
  #   end
  # end

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

    def initialize( features )
      @features              = insert_gaps_between( features )
      @text_width            = 10
      @gap_width             = 5
      @text_height           = 20
      @cassette_width        = calculate_width()
      @cassette_height       = 100
      @sequence_stroke_width = 2.5
      @image                 = Image.new( @cassette_width, @cassette_height )
    end

    # find sum of feature labels
    def calculate_width
      width, gaps = 0, 0
      @features.each do |feature|
        if feature[:name] == "gap"
          gaps += @gap_width
        else
          width += feature[:name].length * @text_width # should check/define feature.width/feature[:width] first
        end
      end
      return width + gaps
    end

    # decide on the need for a gap/space. we need one:
    # + after each SSR_site unless its the last feature in the cassette region
    # + before each SSR_site unless its the first feature in the cassette region
    def insert_gaps_between( features )
      features_with_gaps = []
      gap_feature        = { :type => "misc_feature", :name => "gap" }
      previous_feature   = nil

      features.each do |feature|
        unless previous_feature.nil?
          case [ previous_feature[:type], feature[:type] ]
          # need a way to say [ "SSR_site", "whatever" ]
          when [ "SSR_site", "misc_feature" ] then
            features_with_gaps.push(gap_feature)
          when [ "SSR_site", "SSR_site" ] then 
            features_with_gaps.push(gap_feature)
          when [ "SSR_site", "promoter" ] then
            features_with_gaps.push(gap_feature)
          when [ "misc_feature", "SSR_site" ] then
            features_with_gaps.push(gap_feature)
          when [ "promoter", "human beta actin promoter" ]
            features_with_gaps.push(gap_feature)
          else
            # do nothing
          end
        end

        features_with_gaps.push(feature)
        previous_feature = feature
      end

      return features_with_gaps
    end

    # draw the sequence
    def draw_sequence( x1, y1, x2, y2 )
      d = Draw.new
      d.stroke("black")
      d.stroke_width( @sequence_stroke_width )
      d.line( x1, y1, x2, y2 )
      d.draw( @image )
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

    # draw the given feature based on the feature name:
    # + there should be one method for each feature
    # + the mappings b/w features and draw method should live in a congig file (idealy)
    def draw_feature( feature, x, y )
      case feature[:name]
      when "FRT" then
        draw_frt( x, y )
      when "loxP" then
        draw_loxp( x, y )
      when "Bgal" then
        draw_cassette_feature( feature[:name], x, y, background_colour = "blue", text_colour = "white" )
      when "neo" then                          
        draw_cassette_feature( feature[:name], x, y, background_colour = "aquamarine", text_colour = "white" )
      when "Bact::neo" then
        draw_cassette_feature( feature[:name], x, y, background_colour = "aquamarine", text_colour = "white" )
      when "IRES" then
        draw_cassette_feature( feature[:name], x, y, background_colour = "orange", text_colour = "white" )
      else                                     
        draw_cassette_feature( feature[:name], x, y )
      end
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
