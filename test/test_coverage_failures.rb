require File.dirname(__FILE__) + '/test_helper.rb'

class TestCoverageFailures < Test::Unit::TestCase
  context 'An updated GenBank file' do
    context 'with a deleted exon overlapping the rcmb primers' do
      setup do
        @data_dir = File.dirname( __FILE__ ) + '/../misc/coverage-failures/fixnum-coercions'
      end
      
      should 'not have Fixnum coercion problems' do
        Dir["#{@data_dir}/*.gbk"].each do |file|
          assert_not_nil AlleleImage::Image.new( file ), "#{ file } instantiates"
        end
      end
    end
  end
end
