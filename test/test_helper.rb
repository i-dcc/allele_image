require 'stringio'
require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'ap'
require 'allele_image'

class AlleleImage::TestCase < Test::Unit::TestCase
  def gbk_fixture(name)
    File.read(File.dirname(__FILE__) + "/fixtures/gbk/#{name}")
  end
end

