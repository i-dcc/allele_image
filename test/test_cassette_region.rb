require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImage < Test::Unit::TestCase

  context "a CassetteRegion" do
    setup do
      @cassette_region = AlleleImage::CassetteRegion.new([
        { :type => "misc_feature", :name => "pA"     },
        { :type => "SSR_site",     :name => "FRT"    },
        { :type => "misc_feature", :name => "En2 SA" },
        { :type => "misc_feature", :name => "Bgal"   },
        { :type => "misc_feature", :name => "neo"    },
        { :type => "misc_feature", :name => "pA"     },
        { :type => "SSR_site",     :name => "FRT"    },
        { :type => "SSR_site",     :name => "loxP"   }
      ])
    end

    should "return true" do
      assert_not_nil @cassette_region
    end

    should "write to a file" do
      assert_instance_of Magick::Image, @cassette_region.write_to_file( "/nfs/users/nfs_i/io1/tmp/cassette_region.png" )
    end
  end

  context "a promoter_driven CassetteRegion" do
    setup do
      @promoter_driven = AlleleImage::CassetteRegion.new([
        { :type => "SSR_site",     :name => "FRT"       },
        { :type => "misc_feature", :name => "En2 SA"    },
        { :type => "misc_feature", :name => "IRES"      },
        { :type => "misc_feature", :name => "Bgal"      },
        { :type => "misc_feature", :name => "pA"        },
        { :type => "SSR_site",     :name => "loxP"      },
        { :type => "promoter",     :name => "Bact::neo" },
        { :type => "misc_feature", :name => "pA"        },
        { :type => "SSR_site",     :name => "FRT"       },
        { :type => "SSR_site",     :name => "loxP"      }
      ])
    end

    should "return true when created" do
      assert_not_nil @promoter_driven
    end

    should "write to a PNG file" do
      assert_instance_of Magick::Image, @promoter_driven.write_to_file( "/nfs/users/nfs_i/io1/tmp/promoter_driven.png" )
    end
  end
end
