#!/usr/bin/env ruby -wKU
require "section"

class Row
  attr_reader :index, :features, :sections, :rcmb_primers

  def initialize(index, features, rcmb_primers)
    @index, @features = index, features
    @rcmb_primers     = rcmb_primers.sort { |a,b| a.start <=> b.start }

    # Allocate the features into their sections
    @sections   = Array.new()
    start_index = 0

    # Let's do the first Section ourselves ...
    @sections.push( Section.new(start_index, @features, nil , @rcmb_primers.first ) )

    # Then loop through the remaining ones
    for i in (0 .. @rcmb_primers.length - 1)
      @sections.push( Section.new(i + 1, @features, @rcmb_primers[i], @rcmb_primers[ i + 1 ] ) )
    end
  end

  def render(format, params={})
    format.new(self).render(params)
  end
end
