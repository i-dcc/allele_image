require File.dirname(__FILE__) + '/test_helper.rb'

class TestCoverageFailures < Test::Unit::TestCase
  context 'An updated GenBank file' do
    context 'for an allele' do
      setup do
        @data_dir = File.dirname( __FILE__ ) + '/../misc/coverage-failures/allele/'
        @alleles  = Dir.entries( @data_dir ).select { |entry| not [".", ".."].include?( entry ) }
      end
      
      should 'not have Fixnum coercion problems' do
        @alleles.each do |file|
          assert_not_nil AlleleImage::Image.new( @data_dir + file ), "#{ @data_dir + file } instantiates"
        end
      end
    end

    context 'for a vector' do
      setup do
        @data_dir = File.dirname( __FILE__ ) + '/../misc/coverage-failures/vector/'
        @vectors  = Dir.entries( @data_dir ).select { |entry| not [".", ".."].include?( entry ) }
      end
      
      should 'not have Fixnum coercion problems' do
        @vectors.each do |file|
          assert_not_nil AlleleImage::Image.new( @data_dir + file ), "#{ @data_dir + file } instantiates"
        end
      end
    end
  end
end
