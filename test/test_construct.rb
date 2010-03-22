require File.dirname(__FILE__) + '/test_helper.rb'

class TestConstruct < Test::Unit::TestCase
  context "a Construct" do
    setup do
      @features       = []
      @circular       = false
      @cassette_label = "Construct 001"
      @construct      = AlleleImage::Construct.new( @features, @circular, @cassette_label )
    end

    should "instantiate" do
      assert_not_nil @construct
      assert_instance_of AlleleImage::Construct, @construct
    end

    # should "" do; end
  end
end
