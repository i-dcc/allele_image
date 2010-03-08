require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImageFiveHomologyRegion < Test::Unit::TestCase
  context "a new FiveHomologyArmRegion" do
    setup do
      @five_arm = AlleleImage::FiveHomologyRegion.new( [
        { :type => "rcmb_primer", :name => "G5"                 },
        { :type => "exon",        :name => "ENSMUSE00000290016" },
        { :type => "exon",        :name => "ENSMUSE0000029001"  },
        { :type => "rcmb_primer", :name => "U5"                 }
      ] )
    end

    should "return true when instantiated" do
      assert_not_nil @five_arm
    end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @five_arm.write_to_file( File.dirname(__FILE__) + "/../misc/five_arm.png" )
    end
  end
end
