require 'test_helper'
require 'ap'

class TestMirKOProducts < Test::Unit::TestCase
  context 'A mirKO product' do
    should 'render a valid image' do
      catch :done_testing do
        Dir["#{File.dirname(__FILE__)}/../misc/mirko/*.gbk"].each do |file|
          if File.size?(file)
            ap "testing #{file}"
            assert_nothing_raised { @allele_image = AlleleImage::Image.new(file) }
            assert_nothing_raised { @magick_image = @allele_image.render }
            assert_nothing_raised { @magick_image.write(file.gsub(/gbk$/, 'gif')) }
            if @allele_image.construct.cassette_features.size > 0
              ap "#{file} has #{@allele_image.construct.cassette_features.size} cassette features"
            end
            # throw :done_testing
          end
        end
      end
    end
  end
end
