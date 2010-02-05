#!/usr/bin/env ruby -wKU

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
    "([ #{ @thing.type }, #{ @thing.position }, #{ @thing.label } ], Feature)"
  end

  def render_section(params)
    "([#{ @thing.features.map{ |x| x.render(RenderAsText) }.join(", ") }], Section)"
  end

  def render_row(params)
    "([#{ @thing.sections.map{ |x| x.render(RenderAsText) }.join(", ") }], Row)"
  end

  def render_grid(params)
    "([#{ @thing.rows.map{ |x| x.render(RenderAsText) }.join(", ") }], Grid)"
  end
end
