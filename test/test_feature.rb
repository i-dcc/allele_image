require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImageFeature < Test::Unit::TestCase
  context "a new AlleleImage::Feature" do
    setup do
      @feature = AlleleImage::Feature.new( "misc_feature", "loxP", 1000, 2000 )
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
      assert_equal "loxP", @feature.feature_name()
    end

    should "have the correct orientation" do
      assert_equal "forward", @feature.orientation()
    end

    should "have the correct width" do
      assert_equal 35, @feature.width()
    end

    context "that is an En2 exon" do
      setup do
        @exon = AlleleImage::Feature.new( "exon", "En2 exon", 10, 100 )
      end

      should "instintiate" do
        assert_not_nil @exon
      end

      should "be an exon" do
        assert_equal "exon", @exon.feature_type
      end

      should "be named 'En2 exon'" do
        assert_equal "En2 exon", @exon.feature_name
      end

      should "have the correct default width" do
        assert_equal 96, @exon.width
      end

      should "have the correct render_options" do
        assert_nil @exon.render_options["label"]
      end
    end
  end
end
