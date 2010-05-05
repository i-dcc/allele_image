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

    should "raise exception with bad data" do
      assert_raise RuntimeError do
        AlleleImage::Feature.new( "A_Feature", "We_Do_Not_Render", 10, 20 )
      end
    end

    should "create exons" do
      exon = AlleleImage::Feature.new( "exon", "ENSMUSE00000317038", 22564, 22712 )
      assert_not_nil exon
      assert_equal "ENSMUSE00000317038", exon.feature_name()
      assert_nil exon.render_options()
    end

    should "have the correct name" do
      assert_equal "pA", @feature.feature_name()
    end
  end
end