#!/usr/bin/env ruby -wKU
require "grid"
require "feature"
require "row"
require "section"

class RenderAsText
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
    # feat  = "([ #{ @thing.type }, #{ @thing.position }, #{ @thing.label } ], Feature)" 
    # feat += " : #{ params[:section].index }" if params[:section]
    # feat
    "([ #{ @thing.type }, #{ @thing.position }, #{ @thing.label } ], Feature)"
  end

  def render_section(params)
  end

  def render_row(params)
  end

  def render_grid(params)
  end
end
