#!/usr/bin/env ruby -wKU
#
# Stub for Section class
#
#   Section.new( features [, width = features.count * factor, height = 100 ] ).to_image -> Magick::Image
#
# Should this be a subclass of Magick::Image?
#

require 'rubygems'
require 'rmagick'

include Magick

class Section

  attr_reader :features, :height, :width

  def initialize( features, height=100, width=0 )
    @features = features   # the features are required
    @height   = height

    # Set the width if given, otherwise calculate from features
    if width > 0
      @width = width
    else
      # should be => calculate_width_from( features.count )
      @width = features.count * 10
    end
  end

  def to_image
    image = Image.new( @width, @height )
  end
end
