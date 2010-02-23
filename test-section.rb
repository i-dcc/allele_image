#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "section"
require "feature"

class TestSection < Test::Unit::TestCase
  context "a new Section" do
    setup do
      @features = [
        Feature.new("exon", 100, 110, "EXON001"),
        Feature.new("exon", 200, 210, "EXON002"),
        Feature.new("exon", 300, 310, "EXON003"),
        Feature.new("exon", 400, 410, "EXON004"),
        Feature.new("exon", 900, 910, "EXON009")
      ]
      @primers = [
        Feature.new("rcmb_primer", 150, 160, "G5"),
        Feature.new("rcmb_primer", 350, 360, "U5")
      ]
      @section1 = Section.new(0, @features, nil, @primers.first)
      @section2 = Section.new(1, @features, @primers.first, @primers.last)
      @section3 = Section.new(2, @features, Feature.new("rcmb_primer", 700, 710, "G3"), nil)
    end

    should "have an index" do
      assert_equal(1, @section2.index)
    end
    
    should "have a bunch of features" do
      assert_equal(1, @section1.features.size)
      assert_equal(2, @section2.features.size)
      assert_equal(1, @section3.features.size)
    end

    should "have bounding primers (at least one)" do
      assert_equal("G5", @section2.lower_primer.label)
      assert_equal("U5", @section2.upper_primer.label)
    end
  end
end
