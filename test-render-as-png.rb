#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "rmagick"
# require "ftools"
require "feature"
require "section"
require "row"
require "grid"
require "render_as_png"

class TestRenderAsPNG < Test::Unit::TestCase
  context "a new Feature" do
    setup do
      @feature = Feature.new("exon", 100, "EXON001")
      @format  = RenderAsPNG
      @section = Image.new(90, 100)
    end

    # needs more thourough tests
    should "render itself as a Magick::Draw object" do
      rendered_feature = @feature.render(@format, :x1 => 10, :x2 => 20, :y1 => 40, :y2 => 60, :section => @section)
      # @section.write("feature.png")
      assert_equal(rendered_feature.class, Magick::Draw)
    end
  end

  context "a new Section" do
    setup do
      @features = [
        Feature.new("exon", 100, "EXON001"),
        Feature.new("exon", 200, "EXON002"),
        Feature.new("exon", 300, "EXON003"),
        Feature.new("exon", 400, "EXON004"),
        Feature.new("exon", 900, "EXON009")
      ]
      @primers = [
        Feature.new("rcmb_primer", 150, "G5"),
        Feature.new("rcmb_primer", 350, "U5")
      ]
      @section = Section.new(0, @features, @primers.first, @primers.last)
      @format  = RenderAsPNG
    end

    should "render itself as a Magick::Image object" do
      rendered_section = @section.render(@format, :width => 45, :height => 100)
      assert_equal(rendered_section.class, Magick::Image)
      # rendered_section.write("section.png")
    end
  end

  context "a new Row" do
    setup do
      @primers = [
        Feature.new("rcmb_primer", 150, "G5"),
        Feature.new("rcmb_primer", 350, "U5"),
        Feature.new("rcmb_primer", 450, "D3"),
        Feature.new("rcmb_primer", 700, "G3")
      ]
      @features = [
        Feature.new("exon", 100, "EXON001"),
        Feature.new("exon", 200, "EXON002"),
        Feature.new("exon", 300, "EXON003"),
        Feature.new("exon", 400, "EXON004"),
        Feature.new("exon", 900, "EXON009")
      ]
      @row     = Row.new(1, @features, @primers)
      @format  = RenderAsPNG
    end

    should "render itself as a Magick::ImageList" do
      rendered_row = @row.render(@format)
      assert_equal(rendered_row.class, Magick::ImageList)
      # rendered_row.write("row.png")
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
