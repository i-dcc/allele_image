#!/usr/bin/env ruby -wKU

require "feature"
require "section"

class RenderAsText
  def initialize(feature)
    @feature = feature
  end
  def render(params)
    feat  = "([ #{ @feature.type }, #{ @feature.position }, #{ @feature.label } } ], Feature)" 
    feat += " : #{ params[:section].index }" if params[:section]
    feat
  end
end

# f1 = Feature.new("exon", 10, "EXON001").render(RenderAsText)
# f2 = Feature.new("exon", 10, "EXON001").render(RenderAsText, :section => Section.new(0, [], Feature.new("rcmb_primer", 10, "G5"), nil))

class RenderAsPNG
  require "rmagick"
  include Magick
  def initialize(feature)
    @feature = feature
  end
  def render(params)
    d = Draw.new
    d.stroke("black")
    d.fill("blue")
    d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
    d.draw(params[:section])
  end
  def render_feature
  end
  def render_section
  end
  def render_row
  end
  def render_grid
  end
end

require "rmagick"
include Magick

i = Image.new(200, 100)
f = Feature.new("exon", 10, "EXON001").render(RenderAsPNG, :section => i, :x1 => 50, :y1 => 25, :x2 => 150, :y2 => 75)
i.display

=begin

## shift + alt to select vertical columns in TextMate
# irb(main):061:0> Text = 'RMagick'
# => "RMagick"
# irb(main):062:0> granite = Magick::ImageList.new('granite:')
# => [granite:=>GRANITE GRANITE 128x128 128x128+0+0 PseudoClass 16c 8-bit 6kb]
# scene=0
# irb(main):063:0> canvas = Magick::ImageList.new
# => []
# scene=
# irb(main):064:0> canvas.new_image(300, 100, Magick::TextureFill.new(granite))
# => [  300x100 DirectClass 16-bit]
# scene=0
# irb(main):065:0> text = Magick::Draw.new
# => (no primitives defined)
# irb(main):066:0> text.font_family = 'helvetica'
# => "helvetica"
# irb(main):067:0> text.pointsize = 52
# => 52
# irb(main):068:0> text.gravity = Magick::CenterGravity
# => CenterGravity=5
# irb(main):069:0> text.annotate(canvas, 0,0,2,2, Text) {
# irb(main):070:1* self.fill = 'gray83'
# irb(main):071:1> }
# => (no primitives defined)
# irb(main):072:0> text.annotate(canvas, 0,0,-1.5,-1.5, Text) {
# irb(main):073:1* self.fill = 'gray40'
# irb(main):074:1> }
# => (no primitives defined)
# irb(main):075:0> text.annotate(canvas, 0,0,0,0, Text) {
# irb(main):076:1* self.fill = 'darkred'
# irb(main):077:1> }
# => (no primitives defined)
# irb(main):078:0> canvas.write('rubyname.gif')
# => [rubyname.gif  300x100 PseudoClass 154c 16-bit]
# scene=0
# irb(main):079:0> 

=end
