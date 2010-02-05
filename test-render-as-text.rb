#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "shoulda"
require "bio"
require "feature"
require "section"
require "row"
require "grid"
require "render_as_text"

# Use textual rendering to test the framework

class TestRenderAsText < Test::Unit::TestCase
  context "a new Feature" do
    setup do
      @feature = Feature.new("exon", 10, "EXON001")
      @primer  = Feature.new("rcmb_primer", 20, "G5")
      @section = Section.new(0, [@feature], nil, @primer)
      @format  = RenderAsText
    end
    
    should "be able to render itself" do
      assert_equal("([ exon, 10, EXON001 ], Feature)", @feature.render(@format))
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
      @format  = RenderAsText
    end

    should "be able to render itself" do
      assert_equal(2, @section.size)
      assert_equal(
        "([([ exon, 200, EXON002 ], Feature), ([ exon, 300, EXON003 ], Feature)], Section)",
        @section.render(@format))
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
      @format  = RenderAsText
    end

    should "be able to render itself" do
      assert_equal(
      "([([([ exon, 100, EXON001 ], Feature)], Section), ([([ exon, 200, EXON002 ], Feature), ([ exon, 300, EXON003 ], Feature)], Section), ([([ exon, 400, EXON004 ], Feature)], Section), ([], Section), ([([ exon, 900, EXON009 ], Feature)], Section)], Row)",
       @row.render(@format))
    end
  end

  context "a new Grid" do
    setup do
      @features = [
        Feature.new("rcmb_primer", 150, "G5"),
        Feature.new("rcmb_primer", 350, "U5"),
        Feature.new("rcmb_primer", 450, "D3"),
        Feature.new("rcmb_primer", 700, "G3"),
        Feature.new("exon", 100, "EXON001"),
        Feature.new("exon", 200, "EXON002"),
        Feature.new("exon", 300, "EXON003"),
        Feature.new("exon", 400, "EXON004"),
        Feature.new("exon", 900, "EXON009")
      ]
      @grid = Grid.new(@features, 0)
    end
    should "be able to render itself" do
      assert_equal(
        "([([([], Section), ([], Section), ([], Section), ([], Section), ([], Section)], Row), ([([([ exon, 100, EXON001 ], Feature)], Section), ([([ exon, 200, EXON002 ], Feature), ([ exon, 300, EXON003 ], Feature)], Section), ([([ exon, 400, EXON004 ], Feature)], Section), ([], Section), ([([ exon, 900, EXON009 ], Feature)], Section)], Row), ([([([ exon, 100, EXON001 ], Feature)], Section), ([([ exon, 200, EXON002 ], Feature), ([ exon, 300, EXON003 ], Feature)], Section), ([([ exon, 400, EXON004 ], Feature)], Section), ([], Section), ([([ exon, 900, EXON009 ], Feature)], Section)], Row)], Grid)",
        @grid.render(RenderAsText))
    end
  end

  context "a Grid with real Features" do
    setup do
      @features = Bio::GenBank.open("./2009_11_27_conditional_linear.gbk").next_entry.features.map do |f|
        Feature.new( f.feature, f.locations.first.from, f.assoc["label"] )
      end
      @grid   = Grid.new(@features, 0)
      @format = RenderAsText
    end

    should "have the correct number of features" do
      assert_equal(@grid.features.size, @features.size)
    end

    should "render itself as a Magick::Image object" do
      puts @grid.render(@format)
    end
  end
end
