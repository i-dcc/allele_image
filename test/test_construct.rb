require 'test_helper'

class TestConstruct < Test::Unit::TestCase
  context "a Conditional Allele" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_allele.gbk"
      @construct = AlleleImage::Parser.new( file ).construct()
    end

    should "instantiate" do
      assert_not_nil @construct
      assert_instance_of AlleleImage::Construct, @construct
    end

    should "have rcmb_primers" do
      assert_not_nil @construct.rcmb_primers()
    end

    should "have cassette features" do
      assert_not_nil @construct.cassette_features()
    end

    should "have 5 arm features" do
      assert_not_nil @construct.five_arm_features()
    end

    should "have 3 arm features" do
      assert_not_nil @construct.three_arm_features()
    end

    should "have no backbone features" do
      assert_nil @construct.backbone_features()
    end

    # Test the behaviour when one of the above is empty.
    # What do yo want/expect to happen?

    should "be linear by default" do
      assert_equal false, @construct.circular()
    end

    should "have flanks when linear" do
      assert_not_nil @construct.five_flank_features()
      assert_not_nil @construct.three_flank_features()
    end
  end

  context "a Conditional Vector" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_vector.gbk"
      @construct = AlleleImage::Parser.new( file ).construct()
    end

    should "instantiate" do
      assert_not_nil @construct
      assert_instance_of AlleleImage::Construct, @construct
    end

    should "have backbone features" do
      assert_not_nil @construct.backbone_features()
      # pp [ :BACK_BONE_FEATURES => @construct.backbone_features() ]
    end

    should "have no flank features" do
      assert_nil @construct.five_flank_features()
      assert_nil @construct.three_flank_features()
    end
  end

  context "A mirKO vector" do
    should "have cassette features" do
      @filename     = "#{File.dirname(__FILE__)}/../misc/mirko/20797.gbk"
      @image_file   = @filename.gsub(/gbk$/, 'gif')
      @params       = { :upstream => 'U3', :downstream => 'D5' }

      assert_nothing_raised { @allele_image = AlleleImage::Image.new(@filename) }
      assert_not_nil @allele_image.construct, "AlleleImage::Construct is nil"
      assert_not_empty @allele_image.construct.cassette_features(@params), "No cassette features"
      assert_nothing_raised { @allele_image.render.write(@image_file) }
      assert_equal true, File.exists?(@image_file), "Can't write GIF file"
    end
  end
end
