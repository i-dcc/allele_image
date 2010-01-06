#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "feature"

class TestFeature < Test::Unit::TestCase
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
