require File.dirname(__FILE__) + '/test_helper.rb'
require "pp"

class TestConstruct < Test::Unit::TestCase
  context "a Construct" do
    setup do
      file       = File.dirname( __FILE__ ) + "/../misc/project_47462_conditional_allele.gbk"
      format     = "GenBank"
      @construct = AlleleImage::Parser.new( file, format ).construct()
    end

    should "instantiate" do
      assert_not_nil @construct
      assert_instance_of AlleleImage::Construct, @construct
    end

    should "have rcmb_primers" do
      assert_not_nil @construct.rcmb_primers()
    end
  end
end
