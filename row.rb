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

    @sections.push( Section.new(0, @features, nil , "G5" ) ) # 5' flank region
    @sections.push( Section.new(0, @features, "G5", "U5" ) ) # 5' homology region
    @sections.push( Section.new(0, @features, "U5", "U3" ) ) # cassette region
    @sections.push( Section.new(0, @features, "U3", "D5" ) ) # target region
    @sections.push( Section.new(0, @features, "D5", "D3" ) ) # loxP region
    @sections.push( Section.new(0, @features, "D3", "G3" ) ) # 3' homology
    @sections.push( Section.new(0, @features, "G3", nil  ) ) # 3' flank region
  end
  
  # # Returns a Section
  # def merge_sections(a, b)
  # end
end
