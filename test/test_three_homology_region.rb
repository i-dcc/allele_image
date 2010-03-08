require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImageThreeHomologyRegion < Test::Unit::TestCase
  context "a new non-conditional ThreeHomologyRegion" do
    setup do
      @non_conditional = AlleleImage::ThreeHomologyRegion.new( [
        { :start => 10, :stop => 20, :type => "rcmb_primer", :name => "U3"                 },
        { :start => 30, :stop => 40, :type => "exon",        :name => "ENSMUSE00000290016" },
        { :start => 50, :stop => 60, :type => "exon",        :name => "ENSMUSE00000290017" },
        { :start => 70, :stop => 80, :type => "rcmb_primer", :name => "G3"                 }
      ] )
    end

    should "return true on instantiation" do
      assert_not_nil @non_conditional
    end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @non_conditional.write_to_file( File.dirname(__FILE__) + "/../misc/non_conditional.png" )
    end
  end

  context "a new conditional ThreeHomologyRegion" do
    setup do
      @conditional = AlleleImage::ThreeHomologyRegion.new( [
        { :start => 10,  :stop => 20,  :type => "rcmb_primer", :name => "U3"                 },
        { :start => 30,  :stop => 40,  :type => "exon",        :name => "ENSMUSE00000290016" },
        { :start => 50,  :stop => 60,  :type => "rcmb_primer", :name => "D5"                 },
        { :start => 70,  :stop => 80,  :type => "SSR_site",    :name => "loxP"               },
        { :start => 90,  :stop => 100, :type => "rcmb_primer", :name => "D3"                 },
        { :start => 110, :stop => 120, :type => "exon",        :name => "ENSMUSE00000290017" },
        { :start => 130, :stop => 140, :type => "rcmb_primer", :name => "G3"                 }
      ] )
    end

    should "return true on instantiation" do
      assert_not_nil @conditional
    end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @conditional.write_to_file( File.dirname(__FILE__) + "/../misc/conditional.png" )
    end
  end
end
