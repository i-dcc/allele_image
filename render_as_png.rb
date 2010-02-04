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

  # A feature needs to know:
  # - which section it needs to add itself to
  # - where on this section it needs to be rendered
  # - what shape it needs to be rendered as
  # These should all be passed in the params
  # (although the shape could be pre-determined from the feature)
  def render_feature(params)
    d = Draw.new
    d.stroke("black")
    d.fill("yellow")
    # this should be some sort of (simple) coordinate
    d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
    d.draw(params[:section])
  end

  # @feature.render(@format, :x1 => 50, :x2 => 150, :y1 => 25, :y2 => 75, :section => @section)
  def render_section(params)
    image = Image.new(params[:width], params[:height])
    coord = 10
    gap   = 5
    feature_width = 10
    @thing.features.each do |feature|
      feature.render( RenderAsPNG, :x1 => coord, :x2 => coord + feature_width, :y1 => 25, :y2 => 75, :section => image )
      # puts "#{feature} [(#{coord}, y1), (x2, y2)]"
      coord += gap + feature_width
    end
    image
  end
  def render_row(params)
  end
  def render_grid(params)
  end
end
