require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImageFeature < Test::Unit::TestCase
  context "an AlleleImage::Feature" do
    context "that is a primer" do
      setup do
        @features = [
         { :type => "primer_bind", :pos => "72048..72067",           :name => "G3", :start => 72048,  :stop => 72067,  :ori => "forward" },
         { :type => "primer_bind", :pos => "1925..1999",             :name => "HU", :start => 1925,   :stop => 1999,   :ori => "forward" },
         { :type => "primer_bind", :pos => "complement(8085..8159)", :name => "HU", :start => 8085,   :stop => 8159,   :ori => "reverse" },
         { :type => "primer_bind", :pos => "-36381..-36362",         :name => "G5", :start => -36381, :stop => -36362, :ori => "forward" },
        ]
      end

      should "instantiate correctly from a Bio::Feature" do
        @features.each do |feature|
          bio_feature = Bio::Feature.new( feature[:type], feature[:pos] )
          bio_feature.append( Bio::Feature::Qualifier.new( "note", feature[:name] ) )

          # check a few basics truths ...
          assert_not_nil bio_feature, "we have a bio feature"
          assert_equal feature[:pos],  bio_feature.position, "get the position"
          assert_equal feature[:name], bio_feature.qualifiers.first.value, "get the note"

          ai_feature = AlleleImage::Feature.new( bio_feature )

          # and now some basics *we hope are true* ...
          assert_not_nil ai_feature, "we can instantiate an AlleleImage::Feature"
          assert_equal feature[:type],  ai_feature.feature_type, "correct type"
          assert_equal feature[:name],  ai_feature.feature_name, "correct name"
          assert_equal feature[:start], ai_feature.start,        "correct start"
          assert_equal feature[:stop],  ai_feature.stop,         "correct stop"
          assert_equal feature[:ori],   ai_feature.orientation,  "correct orientation"
        end
      end
    end

    context "that is an exon" do
      setup do
        @features = []
      end
    end

    context "that is not renderable" do
      setup do
        @features = []
      end
    end

    context "that has render options" do
      setup do
        @features = []
      end
    end
  end

=begin
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
=end
end
