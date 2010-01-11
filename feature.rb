#!/usr/bin/env ruby -wKU

class Feature
  attr_reader :type, :position, :label
  
  def initialize(type, position, label)
    @type, @position, @label = type, position, label
  end
  
  def render(format, params={})
    format.new(self).render(params)
  end
end
