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
        Feature.new("rcmb_primer", 80, "G5"),
        Feature.new("lrpcr_primer", 10, nil),
        Feature.new("genomic", 60, nil),
        Feature.new("c", 100, nil),
        Feature.new("d", 110, nil)
      ]
      
      @is_circular = 0
      
      @grid = Grid.new(@features, @is_circular)
    end
    
    should "have some features" do
      assert_equal(5, @grid.features.size)
    end
    
    should "have sorted features" do
      assert_equal( 10, @grid.features.first.position)
      assert_equal(110, @grid.features.last.position )
    end
    
    should "have some annotation features" do
      assert_equal(2, @grid.annotation_features.size)
    end
    
    should "have some main features" do
      assert_equal(2, @grid.main_features.size)
    end
    
    should "have some rcmb primers" do
      assert_equal(1, @grid.rcmb_primers.size)
    end
    
    should "have 3 rows when not circular" do
      assert_equal(3, @grid.rows.size)
    end
  end
end
