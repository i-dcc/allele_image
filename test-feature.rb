#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "feature"

class TestFeature < Test::Unit::TestCase
  context "a new Feature" do
    setup do
      @feature = Feature.new("rcmb_primer", 80, 100, "G5")
    end

    should "be of type 'rcmb_primer'" do
      assert_equal('rcmb_primer', @feature.type)
    end

    should "be at start 80" do
      assert_equal(80, @feature.start)
    end

    should "have label 'G5'" do
      assert_equal("G5", @feature.label)
    end

    should "be renderable" do
    end
  end
end
