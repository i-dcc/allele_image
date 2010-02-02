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
