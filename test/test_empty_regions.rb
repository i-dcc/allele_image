require File.dirname(__FILE__) + '/test_helper.rb'

class TestEmptyRegions < Test::Unit::TestCase
  context "An updated GenBank file" do
    setup do
      @base_dir = File.dirname( __FILE__ ) + '/../misc/known-issues/empty-regions'
    end

    [ 'allele', 'vector' ].each do |construct|
      context "for a(n) #{ construct } with empty spaces" do
        setup do
          @data_dir = @base_dir + "/#{ construct }"
        end

        should "" do
          Dir["#{@data_dir}/*.gbk"].each do |file|
            assert_not_nil AlleleImage::Image.new( file ), "#{ file } instantiates"
          end
        end
      end
    end
  end
end
