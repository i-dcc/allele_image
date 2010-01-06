#!/usr/bin/env ruby -wKU

class Section
  attr_reader :index, :features, :primer_5, :primer_3
  
  def initialize(index, features)
    @index, @features = index, features
  end
end
