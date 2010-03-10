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

    should "be as wide as the longest exon name length (18) * the text width (10)" do
      assert_equal 180, @five_arm.width
    end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @five_arm.write_to_file( File.dirname(__FILE__) + "/../misc/five_arm.png" )
    end
  end

  context "a 5' arm with many exons" do
    setup do
      @many_exons = AlleleImage::FiveHomologyRegion.new( [
        { :type => "rcmb_primer", :name => "G5"                 },
        { :type => "exon",        :name => "ENSMUSE00000290011" },
        { :type => "exon",        :name => "ENSMUSE00000290012" },
        { :type => "exon",        :name => "ENSMUSE00000290013" },
        { :start => 10450, :stop => 15051, :type => "genomic",     :name => "5 arm"              },
        { :type => "exon",        :name => "ENSMUSE00000290014" },
        { :type => "exon",        :name => "ENSMUSE00000290015" },
        { :type => "exon",        :name => "ENSMUSE0000029001"  },
        { :type => "rcmb_primer", :name => "U5"                 }
      ] )
    end

    should "be as wide as the longest exon name length (18) * the text width (10)" do
      assert_equal 180, @many_exons.width
    end

    # should "annotate correctly" do
    #   assert_instance_of Magick::Image, @many_exons.annotate_region( "5' homology arm" )
    #   @many_exons.annotate_region( "5' homology arm" ).write( File.dirname(__FILE__) + "/../misc/5_homology_arm.png" )
    # end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @many_exons.write_to_file( File.dirname(__FILE__) + "/../misc/many_exons.png" )
    end
  end
end
