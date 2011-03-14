require 'test_helper'

class TestCoverageFailures < Test::Unit::TestCase
  context 'An updated GenBank file' do
    setup do
      @dir = File.dirname( __FILE__ ) + '/../misc/coverage-failures'
    end

    context 'with a deleted exon overlapping the rcmb primers' do
      setup do
        @data_dir = @dir + '/fixnum-coercions'
      end
      
      should 'not throw Fixnum coercion error' do
        Dir["#{@data_dir}/*.gbk"].each do |file|
          assert_not_nil AlleleImage::Image.new( file ), "#{ file } instantiates"
        end
      end
    end

    # this fails due to 2 *G5* features annotated in GenBank file
    context "that throws: undefined method `feature_name' for nil:NilClass" do
      setup do
        @data_dir =  @dir + "/undefined-feature_name"
      end

      should 'not throw undefined feature_name error' do
        Dir["#{@data_dir}/*.gbk"].each do |file|
          assert_not_nil AlleleImage::Image.new( file ), "#{ file } instantiates"
        end
      end
    end
  end
end
