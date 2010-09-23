require File.dirname(__FILE__) + '/test_helper.rb'

class TestEmptyRegions < Test::Unit::TestCase
  context "An updated GenBank file" do
    setup do
      @base_dir = File.dirname( __FILE__ ) + '/../misc/known-issues/empty-regions'
    end

    [ 'allele', 'vector' ].each do |construct|
      context "for a(n) #{ construct } with empty spaces" do
        setup do
          # TODO: work out correct width and use instead
          @data_dir    = @base_dir + "/#{ construct }"
          @wrong_width = 1300
        end

        should "" do
          Dir["#{@data_dir}/*.gbk"].each do |file|
            allele_image = AlleleImage::Image.new( file )
            assert_not_nil allele_image, "#{ file } instantiates"
            assert_not_equal(
              @wrong_width, allele_image.render.columns,
              "#{ file } should not be #{ @wrong_width } pixels wide" )
          end
        end
      end
    end
  end
end
