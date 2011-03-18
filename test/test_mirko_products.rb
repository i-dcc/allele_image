require 'test_helper'
require 'ap'

class TestMirKOProducts < Test::Unit::TestCase
  context 'A mirKO product' do
    should 'render a valid image' do
      catch :done_testing do
        Dir["#{File.dirname(__FILE__)}/../misc/mirko/*.gbk"].each do |file|
          if File.size?(file)
            assert_nothing_raised do
              @allele_image = AlleleImage::Image.new(file)
            end
            throw :done_testing
          end
        end
      end
    end
  end
end
