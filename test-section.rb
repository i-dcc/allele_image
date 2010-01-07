#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "section"

class TestSection < Test::Unit::TestCase
  context "a new Section" do
    setup do
      # Need to test with non-empty data
      @section = Section.new(0, [], "G5", "U5")
    end

    should "have an index" do
      assert_equal(0, @section.index)
    end

    should "have a bunch of features" do
      assert_equal(0, @section.features.size)
    end

    should "have bounding primers (at least one)" do
      assert_equal("G5", @section.lower_primer)
      assert_equal("U5", @section.upper_primer)
    end
  end
end
