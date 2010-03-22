require File.dirname(__FILE__) + '/test_helper.rb'

# s/Namespace/Something more appropriate/g when all is done
module Namespace
  # == SYNOPSIS
  #   construct = Namespace::Construct.new( features, circular, cassette_label )
  # 
  # == ATTRIBUTES
  # * features
  # * circular
  # * cassette_label
  # 
  # == METHODS
  # * cassette_features
  # * five_arm_features
  # * three_arm_features
  # 
  # The following methods may return nil
  # * backbone_features
  # * five_flank_features
  # * three_flank_features
  # 
  class Construct
    attr_reader :circular, :features, :cassette_label, :rcmb_primers

    def initialize( features, circular, cassette_label )
      @rcmb_primers = initialize_rcmb_primers( features )
      @features     = features
    end

    # These methods always return something
    def cassette_features; end
    def five_arm_features; end
    def three_arm_features; end

    # These would return nil depending on if the
    # Construct is an Allele or a Vector
    def backbone_features; end
    def five_flank_features; end
    def three_flank_features; end

    private
      def initialize_rcmb_primers( features )
      end
  end
end

class TestConstruct < Test::Unit::TestCase
  context "a Construct" do
    setup do
      @features       = []
      @circular       = false
      @cassette_label = "Construct 001"
      @construct      = Namespace::Construct.new( @features, @circular, @cassette_label )
    end

    should "instantiate" do
      assert_not_nil @construct
      assert_instance_of Namespace::Construct, @construct
    end

    # should "" do; end
  end
end
