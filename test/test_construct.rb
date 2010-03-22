require File.dirname(__FILE__) + '/test_helper.rb'

# s/Namespace/Something more appropriate/g when all is done
module Namespace
  # == SYNOPSIS
  #   construct = Namespace::Construct.new( features, circular, label )
  # 
  # == ATTRIBUTES
  # * features
  # * circular
  # * label
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
  end
end

class TestConstruct < Test::Unit::TestCase
  context "a Construct" do
    setup do
    end
  end
end
