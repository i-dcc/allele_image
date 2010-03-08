$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "RMagick"
require "pp"

include Magick

# This entire module could do with a better name
module AlleleImage
  VERSION = '0.0.1'

  class Image
    include AlleleImage

    attr_reader :features, :rcmb_primers, :cassette_features, :five_homology_features
    attr_reader :three_homology_features

    # Need a smarter way of obtaining the format (in the long run) than supplying an argument
    # Should also (for example) be able to instantiate a new AlleleImage::Image from a list of
    # features
    def initialize( file, input_format = "Genbank" )
      @features = eval( "AlleleImage::Parse::#{ input_format }" ).new( file ).features

      # Collect the rcmb_primers
      @rcmb_primers = @features.select { |feature| feature[:type] == "rcmb_primer" }

      # SORT THE FEATURES INTO REGIONS BASED ON rcmb_primers ABOVE
      @cassette_features = @features.select do |feature|
        feature[:start] >= @rcmb_primers[1][:start] and feature[:start] <= @rcmb_primers[3][:start]
      end

      @five_homology_features = @features.select do |feature|
        feature[:start] >= @rcmb_primers[0][:start] and feature[:start] <= @rcmb_primers[1][:start]
      end

      @three_homology_features = @features.select do |feature|
        feature[:start] >= @rcmb_primers[2][:start] and feature[:start] <= @rcmb_primers.last[:start]
      end
    end

    # Put the different sections together here
    def render
      cassette_region = AlleleImage::CassetteRegion.new( @cassette_features ).render()
    end
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
          features_with_gaps.push( gap_feature )
        when [ "SSR_site", "SSR_site" ] then
          features_with_gaps.push( gap_feature )
        when [ "SSR_site", "promoter" ] then
          features_with_gaps.push( gap_feature )
        when [ "misc_feature", "SSR_site" ] then
          features_with_gaps.push( gap_feature )
        when [ "promoter", "human beta actin promoter" ]
          features_with_gaps.push( gap_feature )
        when [ "exon", "exon" ]
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
    begin
      self.render().write( file )
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
require File.join( directory, 'allele_image', 'parse', 'genbank' )
