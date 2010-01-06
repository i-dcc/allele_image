#!/usr/bin/env ruby -wKU

class Row
  attr_reader :index, :sections, :rcmb_primers

  # should these be features not sections?
  # should the rows have names not indexes?
  def initialize(index, sections)
    @index, @sections = index, sections
  end
  
  # Returns a Section
  def merge_sections(a, b)
  end
end
