#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "grid"

class TestGrid < Test::Unit::TestCase
  context "a new Grid" do
    setup do
      # Generating the feature list will be factored out as well
      @features = [
        { "name" => "rcmb_primer", "position" => 80 },
        { "position" => 10 },
        { "position" => 60 },
        { "position" => 100 },
        { "position" => 110 }
      ]
      
      @grid = Grid.new(@features)
    end
    
    should "have some features" do
      assert_equal(5, @grid.features.count)
    end

    should "have sorted features" do
      assert_equal( 10, @grid.features.first["position"])
      assert_equal(110, @grid.features.last["position"] )
    end

    should "have some rcmb primers" do
      assert_equal(1, @grid.primers.size)
    end
  end
end
