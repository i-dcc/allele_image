#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "render"
require "feature"

class TestRender < Test::Unit::TestCase
  context "" do
    setup do
      @thing  = Feature.new("exon", 10, "EXON001")
      @format = "text"
      @render = Render.new(@thing, @format)
    end
    
    should "" do
      
    end
  end
end