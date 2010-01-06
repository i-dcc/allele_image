#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "feature"

class TestFeature < Test::Unit::TestCase
  # Test the Feature class
  context "a new Feature" do
    setup do
      @feature = Feature.new("rcmb_primer", 80, "G5")
    end
    
    should "be of type 'rcmb_primer'" do
      assert_equal('rcmb_primer', @feature.type)
    end
    
    should "be at position 80" do
      assert_equal(80, @feature.position)
    end
    
    should "have label 'G5'" do
      assert_equal("G5", @feature.label)
    end
  end
end
