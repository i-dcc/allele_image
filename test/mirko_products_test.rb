require 'test_helper'

class TestMirKOProducts < Test::Unit::TestCase
  context 'A mirKO product' do
    setup do
      @cassette_features = ['loxP', 'F3', 'PGK', 'pu-Delta-tk', 'pA', 'loxP', 'FRT']
    end

    should 'render a valid image' do
      catch :done_testing do
        Dir["#{File.dirname(__FILE__)}/../misc/mirko/*.gbk"].each do |file|
          if File.size?(file)
            assert_nothing_raised { @allele_image = AlleleImage::Image.new(file) }
            assert_nothing_raised { @magick_image = @allele_image.render }
            assert_nothing_raised { @magick_image.write(file.gsub(/gbk$/, 'gif')) }
            assert_equal @cassette_features, @allele_image.construct.cassette_features.map(&:feature_name)
            throw :done_testing
          end
        end
      end
    end
  end
end
