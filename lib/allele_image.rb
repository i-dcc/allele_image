$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "RMagick"
require "pp"

include Magick

module AlleleImage
  VERSION = '0.0.1'

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

directory = File.expand_path( File.dirname(__FILE__) )

require File.join( directory, 'allele_image', 'cassette_region' )
