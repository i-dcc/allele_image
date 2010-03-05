$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "bio"
require "RMagick"
require "pp"

include Magick

# This entire module could do with a better name
module AlleleImage
  VERSION = '0.0.1'

  class Image
    attr_reader :features, :rcmb_primers, :cassette_features, :five_homology_features

    # Need a smarter way of obtaining the format (in the long run) than supplying an argument
    # Should also (for example) be able to instantiate a new AlleleImage::Image from a list of
    # features
    def initialize( file, input_format = "Genbank" )
      parse_result            = eval( "AlleleImage::Parse::#{ input_format }" ).new( file )
      @features               = parse_result.features
      @rcmb_primers           = parse_result.rcmb_primers
      @cassette_features      = parse_result.cassette_features
      @five_homology_features = parse_result.five_homology_features
    end

    # write the image to a file
    def write_to_file( file )
      begin
        self.render().write( file )
      rescue Magick::ImageMagickError => error
        puts "Magick::ImageMagickError: " + error
      rescue
        puts "Problems writing image to file: #{ file }"
      end
    end
  end
end

directory = File.expand_path( File.dirname(__FILE__) )

require File.join( directory, 'allele_image', 'cassette_region' )
require File.join( directory, 'allele_image', 'parse', 'genbank' )
