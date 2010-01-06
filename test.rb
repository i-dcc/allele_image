#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "grid"
require "feature"
require "row"
require "section"

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

  # Test the Row class
  context "a new Row" do
    setup do
      @row = Row.new(0, []) # index, sections
    end

    # should "know which Grid it belongs to (I think)" do
    # end

    should "allow access to its Sections" do
      assert_equal(0, @row.sections.size)
    end
    
    should "allow access to its index" do
      assert_equal(0, @row.index)
    end
    
    should "be able to merge 2 Sections" do
      # write a test
    end
  end

  # Test the Section class
  context "a new Section" do
    setup do
      @section = Section.new(0, [])
    end

    should "have an index, a bunch of features and bounding primers (at least one)" do
      assert_equal(0, @section.index)
      assert_equal(0, @section.features.size)
      assert_equal(nil, @section.primer_5)
      assert_equal(nil, @section.primer_3)
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
