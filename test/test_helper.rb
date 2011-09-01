require 'stringio'
require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'ap'
require 'allele_image'
require 'ruby-debug'

class AlleleImage::TestCase < Test::Unit::TestCase
  TEST_ROOT = File.expand_path(File.dirname(__FILE__))

  def gbk_fixture(name)
    File.read(File.dirname(__FILE__) + "/fixtures/gbk/#{name}")
  end
end
