require File.dirname(__FILE__) + '/test_helper.rb'

class TestMissingExons < Test::Unit::TestCase
  context 'An updated GenBank file' do
    setup do
      @data_dir = File.dirname( __FILE__ ) + '/../misc/known-issues/missing-exons'
    end

    context 'with missing exons' do
      should 'display all its exons' do
        Dir["#{@data_dir}/*.gbk"].each do |file|
          image = AlleleImage::Image.new(file)
          assert_not_nil image, 'we have an image'
          three_flank_features = image.construct.three_flank_features
          assert_equal 4, three_flank_features.size, 'we have 3 flank features'
          # pp [
          #     :three_flank_features => three_flank_features
          #     # :annotation_height => image.annotation_height
          #    ]
          image.render.write( file.gsub( /\.\w+$/, '.png' ) )
        end
      end
    end
  end
end
