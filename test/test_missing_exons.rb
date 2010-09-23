require File.dirname(__FILE__) + '/test_helper.rb'
require 'pp'

class TestMissingExons < Test::Unit::TestCase
  context 'An updated GenBank file' do
    setup do
      @data_dir = File.dirname( __FILE__ ) + '/../misc/known-issues/missing-exons'
      @allele   = {
        "test/../misc/known-issues/missing-exons/12299.gbk" => { :feature_count => 5, :height => 260 },
        "test/../misc/known-issues/missing-exons/10406.gbk" => { :feature_count => 4, :height => 240 }
      }
    end

    context 'with missing exons' do
      should 'display all its exons' do
        Dir["#{@data_dir}/*.gbk"].each do |file|
          allele_image = AlleleImage::Image.new(file)

          assert_not_nil allele_image, "#{ file } has an allele_image"

          three_flank_features = allele_image.construct.three_flank_features
          assert_equal( @allele[file][:feature_count],
            three_flank_features.size, "#{file} has the correct number of features" )
          assert_equal( @allele[file][:height],
            allele_image.render.rows, "#{file} has the correct height" )
          # allele_image.render.write( file.gsub( /\.\w+$/, '.png' ) )
          # pp [
          #     file => [
          #              :count => @allele[file][:feature_count],
          #              :height => allele_image.render.rows
          #             ]
          #    ]
        end
      end
    end
  end
end
