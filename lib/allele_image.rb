$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "RMagick"
require "pp"

include Magick

# This entire module could do with a better name
module AlleleImage
  VERSION = '0.0.2'

  class Image
    include AlleleImage

    attr_reader :features, :rcmb_primers, :cassette_features, :five_homology_features
    attr_reader :three_homology_features

    # Need a smarter way of obtaining the format (in the long run) than supplying an argument
    # Should also (for example) be able to instantiate a new AlleleImage::Image from a list of
    # features
    def initialize( file, input_format = "Genbank" )
      parsed_object  = eval( "AlleleImage::Parse::#{ input_format }" ).new( file )
      @features      = parsed_object.features
      @features      = select_renderable_features( @features )
      @cassette_type = parsed_object.cassette_type # "Promoterless Cassette\n(L1L2_gt2)"

      # Collect the rcmb_primers
      @rcmb_primers = @features.select { |feature| feature[:type] == "rcmb_primer" }

      @five_flank_features  = @features.select { |feature| feature[:start] < @rcmb_primers.first[:start] }
      @three_flank_features = @features.select { |feature| feature[:start] > @rcmb_primers.last[:stop] }

      # SORT THE FEATURES INTO REGIONS BASED ON rcmb_primers ABOVE
      @cassette_features = @features.select do |feature|
        feature[:start] >= @rcmb_primers[1][:start] and \
        feature[:start] <= @rcmb_primers[2][:start] and \
        not [ "exon", "rcmb_primer" ].include?( feature[:type] )
        # "rcmb_primer" != feature[:type]
      end

      # Convert to use AlleleImage::RENDERABLE_FEATURES "labels" if available
      @cassette_features.each do |feature|
        feature[:name] = AlleleImage::RENDERABLE_FEATURES[feature[:type]][feature[:name]]["label"] || feature[:name]
      end

      @five_homology_features = @features.select do |feature|
        feature[:start] >= @rcmb_primers[0][:start] and feature[:start] <= @rcmb_primers[1][:start]
      end

      @three_homology_features = @features.select do |feature|
        feature[:start] >= @rcmb_primers[2][:start] and feature[:start] <= @rcmb_primers.last[:start]
      end
    end

    # Put the different sections together here
    # I have somehow managed to merge the rendering and sorting code here.
    # Separate them again later so we can render wit different formats.
    def render
      five_flank  = AlleleImage::FiveHomologyRegion.new( @five_flank_features )
      five_arm    = AlleleImage::FiveHomologyRegion.new( @five_homology_features )
      cassette    = AlleleImage::CassetteRegion.new( @cassette_features, @cassette_type )
      three_arm   = AlleleImage::ThreeHomologyRegion.new( @three_homology_features )
      three_flank = AlleleImage::FiveHomologyRegion.new( @three_flank_features )

      # HANDLE THE ANNOTATIONS
      # Annotate 5' arm
      five_arm_ann = Magick::ImageList.new.push(
        draw_homology_arm(
          Magick::Image.new( five_arm.calculate_width(), 75 ),
          "5' homology arm\n(#{ @rcmb_primers[1][:stop] - @rcmb_primers[0][:start] } bp)"
      ) ).push( five_arm.render ).append( true )

      # Annotate cassette
      cassette_ann = Magick::ImageList.new.push(
        # draw in the annotations
        Magick::Image.new( cassette.calculate_width(), 75 )
      ).push( cassette.render ).append( true )

      # Annotate 3' arm
      three_arm_ann = Magick::ImageList.new.push(
        draw_homology_arm(
          # Perhaps I should have an @image attribute from which we
          # could retrieve the dimensions if we need them rather than
          # this Magick::Image.render.columns() hack we have here.
          Magick::Image.new( three_arm.render.columns, 75 ),
          "3' homology arm\n(#{ @rcmb_primers.last[:stop] - @rcmb_primers[2][:start] } bp)"
      ) ).push( three_arm.render ).append( true )

      # Annotate the flanks
      five_flank_ann = Magick::ImageList.new.push(
        Magick::Image.new( five_flank.calculate_width, 75 )
      ).push( five_flank.render ).append( true )

      three_flank_ann = Magick::ImageList.new.push(
        Magick::Image.new( three_flank.calculate_width, 75 )
      ).push( three_flank.render ).append( true )

      Magick::ImageList.new.push( five_flank_ann ).push( five_arm_ann ).push(
        cassette_ann ).push( three_arm_ann ).push( three_flank_ann ).append( false )
    end
  end

  def draw_label( label, image, x, y )
    d = Magick::Draw.new
    d.stroke( "black" )
    d.fill( "white" )
    d.draw( image )
    d.annotate( image, self.calculate_width, @text_height, x, y, label ) do
      self.fill    = "blue"
      self.gravity = CenterGravity
    end
  end

  # Calculate the correct height to draw the homology arms
  def draw_homology_arm( image, label )
    d = Draw.new
    y = image.rows / 2
    w = image.columns - 1
    h = image.rows / 5 # overhang

    # Draw the lines
    d.stroke( "black" )
    d.stroke_width( 2.5 )
    d.line( 0, y + h, 0, y ).draw( image )
    d.line( 0, y, w, y ).draw( image )
    d.line( w, y, w, y + h ).draw( image )

    # annotate the block
    d.annotate( image, w, y, 0, 0, label ) do
      self.fill    = "blue"
      self.gravity = CenterGravity
    end

    image
  end

  def select_renderable_features( features )
    features.select do |feature|
      feature[ :type ] == "exon" or \
      ( AlleleImage::RENDERABLE_FEATURES[ feature[ :type ] ] and \
        AlleleImage::RENDERABLE_FEATURES[ feature[ :type ] ][ feature[ :name ] ] )
    end
  end

  # draw the given feature based on the feature name:
  # + there should be one method for each feature
  # + the mappings b/w features and draw method should live in a congig file (idealy)
  # 
  # ACTUALLY THE BEST SETUP WOULD BE A FEATURE CLASS WITH A RENDER METHOD:
  # 
  #  Feature#render( FORMAT, LOCUS )
  # 
  def draw_feature( feature, x, y )
    case feature[:name]
    when "FRT"
      draw_frt( x, y )
    when "loxP"
      draw_loxp( x, y )
    when "Bgal"
      draw_cassette_feature( feature[:name], x, y, background_colour = "blue", text_colour = "white" )
    when "neo"
      draw_cassette_feature( feature[:name], x, y, background_colour = "aquamarine", text_colour = "white" )
    when "Bact::neo"
      draw_cassette_feature( feature[:name], x, y, background_colour = "aquamarine", text_colour = "white" )
    when "IRES"
      draw_cassette_feature( feature[:name], x, y, background_colour = "orange", text_colour = "white" )
    else
      draw_cassette_feature( feature[:name], x, y )
    end
  end

  # draw the sequence
  def draw_sequence( x1, y1, x2, y2 )
    d = Draw.new
    d.stroke( "black" )
    d.stroke_width( @sequence_stroke_width )
    d.line( x1, y1, x2, y2 )
    # pp [ "allele_image#draw_sequence(#{[ x1, y1, x2, y2 ].join(',')})" => @image ]
    d.draw( @image )
  end

  # decide on the need for a gap/space. we need one:
  # + after each SSR_site unless its the last feature in the cassette region
  # + before each SSR_site unless its the first feature in the cassette region
  def insert_gaps_between( features )
    features_with_gaps = []
    gap_feature        = { :type => "misc_feature", :name => "gap" }
    previous_feature   = nil

    return features_with_gaps unless features

    features.each do |feature|
      unless previous_feature.nil?
        case [ previous_feature[:type], feature[:type] ]
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

      features_with_gaps.push(feature)
      previous_feature = feature
    end

    return features_with_gaps
  end

  # write the image to a file
  def write_to_file( file )
    image = self.render()
    begin
      image.write( file )
    # Need to handle more types of errors (I think)
    rescue Magick::ImageMagickError => error
      puts "Magick::ImageMagickError: " + error
    rescue
      puts "Problems writing image to file: #{ file }"
    end
  end
end

directory = File.expand_path( File.dirname(__FILE__) )

require File.join( directory, 'allele_image', 'cassette_region' )
require File.join( directory, 'allele_image', 'five_homology_region' )
require File.join( directory, 'allele_image', 'three_homology_region' )
require File.join( directory, 'allele_image', 'renderable_features' )
require File.join( directory, 'allele_image', 'parse', 'genbank' )
require File.join( directory, 'bio', 'genbank', 'locus' )
