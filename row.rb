#!/usr/bin/env ruby -wKU
require "section"

class Row
  attr_reader :index, :features, :sections

  def initialize(index, features)
    @index, @features = index, features
    
    # Allocate the features into their sections
    @sections = []
  end
  
  # Returns a Section
  def merge_sections(a, b)
  end
end
