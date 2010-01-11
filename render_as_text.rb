#!/usr/bin/env ruby -wKU
require "feature"
require "section"

class RenderAsText
  def initialize(feature)
    @feature = feature
  end

  def render(params)
    self.render_feature(params)
  end

  def render_feature(params)
    feat  = "([ #{ @feature.type }, #{ @feature.position }, #{ @feature.label } } ], Feature)" 
    feat += " : #{ params[:section].index }" if params[:section]
    feat
  end
end
