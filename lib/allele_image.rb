$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'bio'
require 'RMagick'

directory = File.expand_path( File.dirname(__FILE__) )

require File.join( directory, 'allele_image', 'construct' )
require File.join( directory, 'allele_image', 'feature' )
require File.join( directory, 'allele_image', 'image' )
require File.join( directory, 'allele_image', 'parser' )
require File.join( directory, 'allele_image', 'renderer' )
require File.join( directory, 'allele_image', 'renderable_features' )

module AlleleImage
end

