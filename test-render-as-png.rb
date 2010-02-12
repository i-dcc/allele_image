#!/usr/bin/env ruby -wKU
require "rubygems"
require "test/unit"
require "bio"
require "shoulda"
require "RMagick"
require "pp"
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
      params = { :x1 => 10, :x2 => 20, :y1 => 40, :y2 => 60, :section => @section, :row_number => 1 }
      rendered_feature = @feature.render(@format, params)
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
      rendered_section = @section.render(@format, :width => 45, :height => 100, :row_number => 1)
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

    should "render itself as a Magick::Image object" do
      rendered_row = @row.render(@format)
      assert_equal(rendered_row.class, Magick::Image)
      # rendered_row.write("row.png")
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
      @grid    = Grid.new(@features, 0)
      @format  = RenderAsPNG
    end

    should "render itself as a Magick::Image object" do
      rendered_grid = @grid.render(@format)
      assert_equal(rendered_grid.class, Magick::Image)
      # pp rendered_grid
      # puts "width: #{rendered_grid.columns}"

      # The following line introduces the error:
      # Magick::ImageMagickError: no pixels defined in cache `' @ cache.c/OpenPixelCache/3941
      # begin
      #   rendered_grid.write("grid.png")
      # rescue ImageMagickError
      #   puts "There was an error writing to 'grid.png'. Investigate and eliminate."
      # end
    end
  end

  context "a conditional allele" do
    setup do
      @features = Bio::GenBank.open("./2009_11_27_conditional_linear.gbk").next_entry.features.map do |f|
        Feature.new( f.feature, f.locations.first.from, f.assoc["label"] )
      end
      @grid   = Grid.new(@features, 0)
      @format = RenderAsPNG
    end

    should "have the correct number of features" do
      assert_equal(@grid.features.size, @features.size)
    end

    should "render itself as a Magick::Image object" do
      rendered_grid = @grid.render(@format)
      assert_equal(rendered_grid.class, Magick::Image)

      # May have to write a "write" method for my Grid class
      begin
        rendered_grid.write("conditional_grid.png")
      rescue ImageMagickError
        puts "There was an error writing to 'grid.png'. Investigate and eliminate."
      end
    end
  end

  context "a non conditional allele" do
    setup do
      @features = Bio::GenBank.open("./2009_11_27_non_conditional_linear.gbk").next_entry.features.map do |f|
        Feature.new( f.feature, f.locations.first.from, f.assoc["label"] )
      end
      @grid   = Grid.new(@features, 0)
      @format = RenderAsPNG
    end

    should "have the correct number of features" do
      assert_equal(@grid.features.size, @features.size)
    end

    should "render itself as a Magick::Image object" do
      rendered_grid = @grid.render(@format)
      assert_equal(rendered_grid.class, Magick::Image)

      # May have to write a "write" method for my Grid class
      begin
        rendered_grid.write("non_conditional_grid.png")
      rescue ImageMagickError
        puts "There was an error writing to 'grid.png'. Investigate and eliminate."
      end
    end
  end

  # Should focus on testing the updated GenBank files here
  # http://www.sanger.ac.uk/htgt/report/gene_report?project_id=35505
  context "a NEW (i.e. up to date) conditional allele" do
    setup do
      @features = Bio::GenBank.open("./2010_02_11_conditional_linear.gbk").next_entry.features.map do |f|
        Feature.new( f.feature, f.locations.first.from, f.assoc["label"] )
      end
      @grid   = Grid.new(@features, 0)
      @format = RenderAsPNG
    end

    should "have the correct number of features" do
      assert_equal(@grid.features.size, @features.size)
    end

    should "render itself as a Magick::Image object" do
      rendered_grid = @grid.render(@format)
      assert_equal(rendered_grid.class, Magick::Image)

      # May have to write a "write" method for my Grid class
      begin
        rendered_grid.write("new_conditional_grid.png")
      rescue ImageMagickError
        puts "There was an error writing to 'grid.png'. Investigate and eliminate."
      end
    end
  end

  context "a NEW (i.e. up to date) non conditional allele" do
    setup do
      @features = Bio::GenBank.open("./2010_02_11_non_conditional_linear.gbk").next_entry.features.map do |f|
        Feature.new( f.feature, f.locations.first.from, f.assoc["label"] )
      end
      @grid   = Grid.new(@features, 0)
      @format = RenderAsPNG
    end

    should "have the correct number of features" do
      assert_equal(@grid.features.size, @features.size)
    end

    should "render itself as a Magick::Image object" do
      rendered_grid = @grid.render(@format)
      assert_equal(rendered_grid.class, Magick::Image)

      # May have to write a "write" method for my Grid class
      begin
        rendered_grid.write("new_non_conditional_grid.png")
      rescue ImageMagickError
        puts "There was an error writing to 'grid.png'. Investigate and eliminate."
      end
    end
  end
end
