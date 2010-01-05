#!/usr/bin/env ruby -wKU

class Grid
  attr_reader :features, :primers

  def initialize(features)
    @features = features.sort do |a,b|
      a["position"] <=> b["position"]
    end

    @primers  = @features.select do |x|
      x["name"] == "rcmb_primer"
    end
  end
  
end
