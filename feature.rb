#!/usr/bin/env ruby -wKU

class Feature
  attr_reader :name, :position
  
  def initialize(name, position)
    @name, @position = name, position
  end
end
