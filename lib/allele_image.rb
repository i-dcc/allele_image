$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"

# This entire module could do with a better name
module AlleleImage
  VERSION = '0.0.2'

end

directory = File.expand_path( File.dirname(__FILE__) )

require File.join( directory, 'allele_image', 'construct' )
require File.join( directory, 'allele_image', 'renderable_features' )
require File.join( directory, 'allele_image', 'feature' )
require File.join( directory, 'allele_image', 'image' )

# == TODO
# Recursively add files in the following directories:
#
require File.join( directory, 'allele_image', 'parser', 'genbank' )
require File.join( directory, 'allele_image', 'renderer', 'png' )
