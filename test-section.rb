#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "section"

class TestSection < Test::Unit::TestCase
  # Test the Section class
  context "a new Section" do
    setup do
      # Need to test with non-empty data
      @section = Section.new(0, [])
    end

    should "have an index" do
      assert_equal(0, @section.index)
    end

    should "have a bunch of features" do
      assert_equal(0, @section.features.size)
    end

    should "have bounding primers (at least one)" do
      assert_equal(nil, @section.primer_5)
      assert_equal(nil, @section.primer_3)
    end
  end
end
