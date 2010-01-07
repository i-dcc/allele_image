#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "row"

class TestRow < Test::Unit::TestCase
  context "a new Row" do
    setup do
      @row = Row.new(0, []) # index, sections
    end

    should "allow access to its Sections" do
      assert_equal(0, @row.sections[0].size)
    end

    should "allow access to its index" do
      assert_equal(0, @row.index)
    end

    should "have 4 to 6 recombineering primers" do
      assert_equal(0, @row.rcmb_primers.size)
    end

    # should "be able to merge 2 Sections" do
    # end
  end
end
