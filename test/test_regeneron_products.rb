require File.dirname( __FILE__ ) + "/test_helper.rb"

class TestRegeneronProducts < Test::Unit::TestCase
  context "" do
    setup do
      @data_dir  = "#{ File.dirname( __FILE__ ) }/../misc/regeneron"
      @cassettes = [
        { :label => "TM-ZEN-UB1", :file => "#{ @data_dir }/11723.gbk",
          :features => [] },
        { :label => "ZEN-Ub1",    :file => "#{ @data_dir }/12890.gbk",
          :features => ["lacZ", "pA", "loxP", "hubiP", "neo", "pA", "pA", "loxP"] },
      ]
    end

    should "" do
      @cassettes.each do |product|
        allele_image = AlleleImage::Image.new( product[:file] )
        features = allele_image.construct.cassette_features.map { |f| f.feature_name }
        allele_image.render.write( product[:file].gsub( /\.gbk$/, ".png" ) )
        assert_not_nil allele_image, "instantiate"
        assert_equal product[:features], features, "have the expected features"
      end
    end
  end
end
