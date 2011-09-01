require 'test_helper'

class TestMissingFeatures < Test::Unit::TestCase
  context 'Knockout-First Allele Cbx1' do
    setup do
      @file         = "#{File.dirname(__FILE__)}/../misc/known-issues/missing-features/902.gbk"
      @allele_image = AlleleImage::Image.new(@file)
      @construct    = @allele_image.construct
    end

    should "have 2 loxP sites in the 3' arm" do
      three_arm_features = [
          "target region",
          "target exon 1 ENSMUSE00000110990",
          "loxP",
          "3 arm",
          "ENSMUSE00000110987"
      ]
      assert @construct
      assert_equal three_arm_features, @construct.three_arm_features.map(&:feature_name)
    end
  end
end
