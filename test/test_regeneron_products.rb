require File.dirname( __FILE__ ) + "/test_helper.rb"

class TestRegeneronProducts < Test::Unit::TestCase
  context "a KOMP-Regeneron product" do
    setup do
      @data_dir  = "#{ File.dirname( __FILE__ ) }/../misc/regeneron"
      @cassettes = {
        "ZEN-Ub1"    => [   "lacZ", "pA", "loxP", "hubiP", "neo", "pA", "loxP"],
        "TM-ZEN-UB1" => ["TM-lacZ", "pA", "loxP", "hubiP", "neo", "pA", "loxP"],
      }
      @files = [
        { :name => "#{ @data_dir }/10381.gbk", :cassette => "ZEN-Ub1"    },
        { :name => "#{ @data_dir }/11723.gbk", :cassette => "TM-ZEN-UB1" },
        { :name => "#{ @data_dir }/12591.gbk", :cassette => "TM-ZEN-UB1" },
        { :name => "#{ @data_dir }/12890.gbk", :cassette => "ZEN-Ub1"    },
      ]
    end

    should "have the correct cassette features" do
      @files.each do |file|
        allele_image = AlleleImage::Image.new( file[:name] )
        features     = allele_image.construct.cassette_features.map { |f| f.feature_name }
        assert_not_nil allele_image, "instantiate"
        assert_equal @cassettes[ file[:cassette] ], features, "have the expected features"
      end
    end
  end
end
