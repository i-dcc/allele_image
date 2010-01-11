#!/usr/bin/env ruby -wKU
require "rmagick"
include Magick

class RenderAsPNG
  def initialize(thing)
    @thing = thing
  end

  def render(params)
    case @thing.class.name
      when "Feature" then self.render_feature(params)
      when "Section" then self.render_section(params)
      when "Row"     then self.render_row(params)
      when "Grid"    then self.render_grid(params)
    end
  end
  
  def render_feature(params)
    d = Draw.new
    d.stroke("black")
    d.fill("blue")
    # this should be some sort of (simple) coordinate
    d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
    d.draw(params[:section])
  end
  def render_section(params)
    i = Image.new(params[:width], params[:height])
    @thing.features.each do |feature|
      feature.render(RenderAsPNG, params)
    end
    i.write("test.png")
  end
  def render_row(params)
  end
  def render_grid(params)
  end
end

require "feature"
require "section"

primers = [
  Feature.new("rcmb_primer", 150, "G5"),
  Feature.new("rcmb_primer", 350, "U5"),
  Feature.new("rcmb_primer", 450, "D3"),
  Feature.new("rcmb_primer", 700, "G3")
]
features = [
  Feature.new("exon", 100, "EXON001"),
  Feature.new("exon", 200, "EXON002"),
  Feature.new("exon", 300, "EXON003"),
  Feature.new("exon", 400, "EXON004"),
  Feature.new("exon", 900, "EXON009")
]
section = Section.new(0, features, primers[0], primers[1])
section.render(RenderAsPNG, :width => 200, :height => 100)

# i = Image.new(200, 100)
# f = Feature.new("exon", 10, "EXON001").render(RenderAsPNG, :section => i, :x1 => 50, :y1 => 25, :x2 => 150, :y2 => 75)
# i.write("test.png")
