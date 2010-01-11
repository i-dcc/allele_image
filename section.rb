#!/usr/bin/env ruby -wKU

class Section
  attr_reader :index, :features, :lower_primer, :upper_primer
  
  def initialize(index, features, lower_primer, upper_primer)
    @index, @lower_primer, @upper_primer = index, lower_primer, upper_primer

    if @lower_primer and @upper_primer
      @features = features.select do |feature|
        feature.position > lower_primer.position and feature.position < upper_primer.position
      end
    elsif @lower_primer and not @upper_primer
      @features = features.select do |feature|
        feature.position > lower_primer.position
      end
    elsif not @lower_primer and @upper_primer
      @features = features.select do |feature|
        feature.position < upper_primer.position
      end
    else
      raise "At least one bounding primer required"
    end
  end
  
  def size
    @features.size
  end

  def render(format, params={})
    format.new(self).render(params)
  end
end
