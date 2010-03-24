require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImageFeature < Test::Unit::TestCase
  context "a new AlleleImage::Feature" do
    setup do
      @feature = AlleleImage::Feature.new( "polyA_site", "SV40 pA", 1000, 2000 )
    end

    should "instintiate" do
      assert_not_nil @feature
      assert_instance_of AlleleImage::Feature, @feature
    end

    should "have the correct name" do
      assert_equal "pA", @feature.feature_name()
    end
  end
end
