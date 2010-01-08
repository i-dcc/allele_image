#!/usr/bin/env ruby -wKU
require "section"

class Row
  attr_reader :index, :features, :sections, :rcmb_primers

  def initialize(index, features, rcmb_primers)
    @index, @features, @rcmb_primers = index, features, rcmb_primers
    
    # Allocate the features into their sections
    @sections = Array.new()

    # Don't like the indexing going on. Should be implicit (I think)
    # Also there should be checks to ensure that the rcmb_primers are actually available

    @sections.push( Section.new(0, @features, nil , "G5" ) ) # 5' flank region
    @sections.push( Section.new(1, @features, "G5", "U5" ) ) # 5' homology region
    @sections.push( Section.new(2, @features, "U5", "U3" ) ) # cassette region
    @sections.push( Section.new(3, @features, "U3", "D5" ) ) # target region
    @sections.push( Section.new(4, @features, "D5", "D3" ) ) # loxP region
    @sections.push( Section.new(5, @features, "D3", "G3" ) ) # 3' homology
    @sections.push( Section.new(6, @features, "G3", nil  ) ) # 3' flank region
  end
  
  # # Returns a Section
  # def merge_sections(a, b)
  # end
end
