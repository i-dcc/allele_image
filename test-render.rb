#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "render"
require "feature"
require "section"
require "row"
require "grid"
require "render_as_text"

# Use textual rendering to test the framework

class TestRenderer < Test::Unit::TestCase
  context "a new Feature" do
    setup do
      @feature = Feature.new("exon", 10, "EXON001")
      @format  = RenderAsText
    end
    
    should "be able to render itself" do
      assert_equal("([ exon, 10, EXON001 } ], Feature)", @feature.render(@format))
    end
  end
end