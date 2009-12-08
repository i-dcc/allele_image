#!/usr/bin/env ruby
#
# Stub for Section class
#
#   Section.new( features [, width = features.count * factor, height = 100 ] ).to_image -> Magick::Image
#
# Should this be a subclass of Magick::Image?
#

class Section
  require "rmagick"
  include Magick

  attr_reader :features, :height, :width

  def initialize( f, h=100, w=200 )
  end

  def to_image
  end
end

# require 'rmagick'
# include Magick
# 
# # can the sections be images/imagelists that we put together?
# # lets prototype the sections on the canvas
# class Section
#   attr_reader :x1, :y1, :x2, :y2, :features
# 
#   def initialize( x1, y1, x2, y2, features )
#     @x1 = x1
#     @x2 = x2
#     @y1 = y1
#     @y2 = y2
#     @features = features
#   end
# 
#   def add_to_canvas(canvas)
#     section = Draw.new
#     section.stroke('black')
#     section.fill('white')
#     section.rectangle(@x1, @y1, @x2, @y2)
#     section.draw(canvas)
#   end
# end
# 
# # .fill before .rectangle
# class Exon
#   attr_reader :x, :y, :height, :width
# 
#   def initialize(x, y, height, width)
#     @x      = x
#     @y      = y
#     @height = height
#     @width  = width
#   end
# 
#   def add_to_canvas(canvas)
#     section = Draw.new
#     section.stroke('black')
#     section.fill('yellow')
#     section.rectangle(@x, @y, @x + @width, @y + @height)
#     section.draw(canvas)
#   end
# end
# 
# canvas = ImageList.new
# canvas.new_image(800, 400)
# 
# s = Section.new(0,0,200,200, ['primer', 'genomic'])
# s.add_to_canvas(canvas)
# puts s.to_yaml
# 
# e = Exon.new(100, 150, 100, 50)
# e.add_to_canvas(canvas)
# puts e.to_yaml
# 
# canvas.write('test_6.png')
