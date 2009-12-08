#!/usr/bin/env ruby
#
# TODO:
# Refactor these out into a method/class that takes arguments:
#
#   Feature.new( name, origin ).draw( image )
#
# where origin is an object representing the locus from which we can extrapolate
# all the points we need to draw any given shape.
#
# Should this be a subclass of Magick::Draw?
#

class Feature
  attr_reader :name, :origin

  def initialize(name, origin)
  end
end
