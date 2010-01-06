#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "grid"
require "feature"

class TestGrid < Test::Unit::TestCase
  # Test the Grid class
  context "a new Grid" do
    setup do
      # Generating the feature list will be factored out as well
      @features = [
        Feature.new("rcmb_primer", 80),
        Feature.new("a", 10),
        Feature.new("b", 60),
        Feature.new("c", 100),
        Feature.new("d", 110)
      ]
      
      @is_circular = 0
      
      @grid = Grid.new(@features, @is_circular)
    end
    
    should "have some features" do
      assert_equal(5, @grid.features.count)
    end

    should "have sorted features" do
      assert_equal( 10, @grid.features.first.position)
      assert_equal(110, @grid.features.last.position )
    end

    should "have some rcmb primers" do
      assert_equal(1, @grid.rcmb_primers.size)
    end
    
    should "have 3 rows when not circular" do
      assert_equal(3, @grid.rows)
    end
  end
  
  # Test the Feature class
  context "a new Feature" do
    setup do
      @feature = Feature.new("rcmb_primer", 80)
    end
    
    should "be named 'rcmb_primer'" do
      assert_equal('rcmb_primer', @feature.name)
    end
    
    should "be at position 80" do
      assert_equal(80, @feature.position)
    end
  end
end
