require File.dirname(__FILE__) + '/test_helper.rb'

class TestAlleleImage < Test::Unit::TestCase
  context "a promoterless CassetteRegion" do
    setup do
      @promoterless = AlleleImage::CassetteRegion.new([
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

    should "return true when created" do
      assert_not_nil @promoterless
    end

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @promoterless.write_to_file( File.dirname(__FILE__) + "/../misc/promoterless.png" )
    end
  end

  context "a promoter_driven CassetteRegion" do
    setup do
      @promoter_driven = AlleleImage::CassetteRegion.new([
        { :type => "SSR_site",     :name => "FRT"       },
        { :type => "misc_feature", :name => "En2 SA"    },
        { :type => "misc_feature", :name => "IRES"      }, # /note="ECMV IRES"
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

    should "write to a PNG file returning a Magick::Image" do
      assert_instance_of Magick::Image, @promoter_driven.write_to_file( File.dirname(__FILE__) + "/../misc/promoter_driven.png" )
    end
  end
end
