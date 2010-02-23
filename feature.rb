#!/usr/bin/env ruby -wKU

class Feature
  attr_reader :type, :start, :stop, :label
  
  def initialize(type, start, stop, label)
    @type, @start, @stop, @label = type, start, stop, label
  end

  def render(format, params={})
    format.new(self).render(params)
  end
end
