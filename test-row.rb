#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "row"
require "feature"

class TestRow < Test::Unit::TestCase
  context "a new Row" do
    setup do
      @primers = [
        Feature.new("rcmb_primer", 150, 160, "G5"),
        Feature.new("rcmb_primer", 350, 360, "U5"),
        Feature.new("rcmb_primer", 450, 460, "D3"),
        Feature.new("rcmb_primer", 700, 710, "G3")
      ]
      @features = [
        Feature.new("exon", 100, 110, "EXON001"),
        Feature.new("exon", 200, 210, "EXON002"),
        Feature.new("exon", 300, 310, "EXON003"),
        Feature.new("exon", 400, 410, "EXON004"),
        Feature.new("exon", 900, 910, "EXON009")
      ]
      @row = Row.new(1, @features, @primers)
    end

    should "allow access to its Sections" do
      assert_equal(5, @row.sections.size)
    end

    should "have correct number of feature per Section" do
      assert_equal(1, @row.sections[0].size)
      assert_equal(2, @row.sections[1].size)
      assert_equal(1, @row.sections[2].size)
      assert_equal(0, @row.sections[3].size)
      assert_equal(1, @row.sections[4].size)
    end

    should "have the correct index on each Section" do
      for i in (0 .. @row.sections.size - 1)
        assert_equal(i, @row.sections[i].index)
      end
    end

    should "allow access to its index" do
      assert_equal(1, @row.index)
    end

    should "have 4 to 6 recombineering primers" do
      assert_equal(4, @row.rcmb_primers.size)
    end
  end
end
