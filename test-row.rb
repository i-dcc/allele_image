#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "row"

class TestRow < Test::Unit::TestCase
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
end
