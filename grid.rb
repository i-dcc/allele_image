#!/usr/bin/env ruby -wKU

class Grid
  attr_reader :features, :rcmb_primers, :rows, :is_circular

  # Not 100% sure if a Grid should have/allow access to @features and @rcmb_primers
  def initialize(features, is_circular)
    @features = features.sort do |a,b|
      a.position <=> b.position
    end

    @rcmb_primers = @features.select do |x|
      x.name == "rcmb_primer"
    end

    @is_circular = is_circular

    @rows = 3
    @rows = 5 if @is_circular == 1
  end
  
end
