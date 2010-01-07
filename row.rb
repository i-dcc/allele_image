#!/usr/bin/env ruby -wKU
require "section"

class Row
  attr_reader :index, :features, :sections, :rcmb_primers

  def initialize(index, features)
    @index, @features = index, features

    @rcmb_primers = @features.select do |x|
      x.name == "rcmb_primer"
    end
    
    # Allocate the features into their sections
    @sections = Array.new()
    
    # 5' flank region
    @sections[0] = @features.select do |x|
      x.position < @rcmb_primer.select{ |y| y.label == "G5" }.position
    end
    
    # 5' homology region
    @sections[1] = @features.select do |x|
          x.position > @rcmb_primer.select{ |y| y.label == "G5" }.position \
      and x.position < @rcmb_primer.select{ |y| y.label == "U5" }.position
    end
    
    # cassette region
    @sections[2] = @features.select do |x|
          x.position > @rcmb_primer.select{ |y| y.label == "U5" }.position \
      and x.position < @rcmb_primer.select{ |y| y.label == "U3" }.position
    end
    
    # target region
    # loxP region
    # 3' homology
    # 3' flank region
  end
  
  # # Returns a Section
  # def merge_sections(a, b)
  # end
end
