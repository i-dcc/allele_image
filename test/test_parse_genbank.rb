require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImageParseGenbank < Test::Unit::TestCase
  context "a new GenBank parser" do
    setup do
      @file   = File.dirname(__FILE__) + "/../misc/project_47462_conditional_allele.gbk"
      @parser = AlleleImage::Parse::Genbank.new( @file )
    end

    should "return true on construction" do
      assert_not_nil @parser
    end

    should "return the correct number of features" do
      assert_equal 69, @parser.features.count
    end

    should "return the correct cassette label" do
      assert_equal "L1L2_Bact_P", @parser.cassette_type
    end
  end
end
