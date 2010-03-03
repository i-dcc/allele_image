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
    # this should also be in a try-catch block itself as sometimes we can't get the fonts
    image = self.render()
    begin
      image.write( file )
    rescue
      puts "Problems writing image to file: #{ file }"
    end
  end
end

directory = File.expand_path( File.dirname(__FILE__) )

require File.join( directory, 'allele_image', 'cassette_region' )
