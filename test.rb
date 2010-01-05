#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "grid"

class TestGrid < Test::Unit::TestCase
  context "a new Grid" do
    setup do
      @features = [
        { "name" => "rcmb_primer" },
        {}, {}, {}, {}
      ]
      
      @grid = Grid.new(@features)
    end
    
    should "have some features" do
      assert_equal(5, @grid.features.count)
    end

    should "have some rcmb primers" do
      assert_equal(1, @grid.primers.size)
    end
  end
end
