#!/usr/bin/env ruby -wKU

class Section
  attr_reader :index, :features, :lower_primer, :upper_primer
  
  def initialize(index, features, lower_primer, upper_primer)
    @index, @lower_primer, @upper_primer = index, lower_primer, upper_primer

    @rcmb_primers = features.select do |x|
      x.name == "rcmb_primer"
    end
    
    if @lower_primer and @upper_primer
      @features = features.select do |x|
            x.position > @rcmb_primer.select{ |y| y.label == @lower_primer }.position \
        and x.position < @rcmb_primer.select{ |y| y.label == @upper_primer }.position
      end
    elsif @lower_primer and not @upper_primer
      @features = features.select do |x|
        x.position < @rcmb_primer.select{ |y| y.label == @lower_primer }.position
      end
    elsif @upper_primer and not @lower_primer
      @features = features.select do |x|
        x.position > @rcmb_primer.select{ |y| y.label == @upper_primer }.position
      end
    end
  end
end
