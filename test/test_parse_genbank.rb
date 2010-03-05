require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImageParseGenbank < Test::Unit::TestCase
  context "a new GenBank parser" do
    setup do
      @parser = AlleleImage::Parse::Genbank.new( File.dirname(__FILE__) + "/../misc/project_47462_conditional_allele.gbk" )
    end

    should "return true on construction" do
      assert_not_nil @parser
    end

    should "return the correct number of features" do
      assert_equal 69, @parser.features.count
    end

    should "return the correct number of rcmb_primers" do
      assert_equal 6, @parser.rcmb_primers.count
    end

    should "return the correct number of cassette features" do
      # check what the correct number for this file should be and adjust
      assert_equal 42, @parser.cassette_features.count
    end
  end
end
