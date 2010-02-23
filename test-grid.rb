#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "grid"
require "feature"

=begin

Need to do a bit more extensive tests with real features, which can be retrieved with the following code:

  require "bio"
  features = Bio::GenBank.open("./2009_11_27_conditional_linear.gbk").next_entry.features.map{ |f| Feature.new( f.feature, f.locations.first.from, f.assoc["label"] ) }

=end

class TestGrid < Test::Unit::TestCase
  context "a new Grid" do
    setup do
      @features = [
        Feature.new("rcmb_primer", 80, 90, "G5"),
        Feature.new("lrpcr_primer", 10, 20, nil),
        Feature.new("genomic", 60, 70, nil),
        Feature.new("c", 100, 105, nil),
        Feature.new("d", 110, 115, nil)
      ]

      @is_circular = 0
      
      @grid = Grid.new(@features, @is_circular)
    end
    
    should "have some features" do
      assert_equal(5, @grid.features.size)
    end
    
    should "have sorted features" do
      assert_equal( 10, @grid.features.first.start)
      assert_equal(110, @grid.features.last.start )
    end
    
    should "have some annotation features" do
      assert_equal(3, @grid.annotation_features.size)
    end
    
    should "have some main features" do
      assert_equal(2, @grid.main_features.size)
    end
    
    should "have some rcmb primers" do
      assert_equal(1, @grid.rcmb_primers.size)
    end
    
    should "have 3 rows when not circular" do
      assert_equal(3, @grid.rows.size)
    end
    
    # should "return the features allocated into sections in a sensible format" do
    #   # puts @grid.to_yaml
    # end
  end
end
