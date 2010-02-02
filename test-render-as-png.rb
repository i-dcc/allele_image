#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "feature"
require "section"
require "row"
require "grid"
require "render_as_png"

class TestRenderAsText < Test::Unit::TestCase
  context "a new Feature" do
    setup do
      @feature = Feature.new("exon", 100, "EXON001")
    end

    should "" do
    end
  end
end

# @primers = [
#   Feature.new("rcmb_primer", 150, "G5"),
#   Feature.new("rcmb_primer", 350, "U5"),
#   Feature.new("rcmb_primer", 450, "D3"),
#   Feature.new("rcmb_primer", 700, "G3")
# ]
# @features = [
#   Feature.new("exon", 100, "EXON001"),
#   Feature.new("exon", 200, "EXON002"),
#   Feature.new("exon", 300, "EXON003"),
#   Feature.new("exon", 400, "EXON004"),
#   Feature.new("exon", 900, "EXON009")
# ]
# section = Section.new(0, features, primers[0], primers[1])
# section.render(RenderAsPNG, :width => 200, :height => 100)

# i = Image.new(200, 100)
# f = Feature.new("exon", 10, "EXON001").render(RenderAsPNG, :section => i, :x1 => 50, :y1 => 25, :x2 => 150, :y2 => 75)
# i.write("test.png")
