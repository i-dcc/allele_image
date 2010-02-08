#!/usr/bin/env ruby -wKU
require "rubygems"
require "RMagick"
require "pp"
include Magick

class RenderAsPNG
  # This bit seems (initialize and render) like something that should be
  # shared between different rendering engines (RenderAsText has the exact
  # same construct)
  def initialize(thing)
    @thing = thing
  end

  def render(params)
    case @thing.class.name
      when "Feature" then self.render_feature(params)
      when "Section" then self.render_section(params)
      when "Row"     then self.render_row(params)
      when "Grid"    then self.render_grid(params)
    end
  end

  # A feature needs to know:
  # - which section it needs to add itself to
  # - where on this section it needs to be rendered
  # - what shape it needs to be rendered as
  # These should all be passed in the params
  # (although the shape could be pre-determined from the feature type)
  def render_feature(params)
    # Let's stick this here so we can have at least an empty rectangle to draw
    d = Draw.new
    d.stroke("black")

    if params[:row_number] == 2
      unless @thing.label
        puts "The following feature has no label:"
        pp @thing
      end
      return d.annotate(params[:section], params[:width], params[:height], params[:x1], params[:y1], @thing.label || "")
    end

    # Here we should be checking the type of the feature and delegating to
    # specific methods for rendering those features.
    case @thing.type
      when "exon" then
        d.fill("yellow")
        # puts "EXON: #{@thing.label}"
      when "misc_feature" then
        d.fill("red")
        # puts "misc_feature: #{@thing.label}"
      when "SSR_site" then
        d.fill("blue")
        # puts "SSR_site: #{@thing.label}"
      when "polyA_site" then
        d.fill("green")
        # puts "polyA_site: #{@thing.label}"
      when "LRPCR_primer" then
        d.fill("violet")
        # puts "LRPCR_primer: #{@thing.label}"
      when "gateway" then
        d.fill("black")
        # puts "gateway: #{@thing.label}"
      else
        puts "cannot handle this feature:"
        pp @thing
        puts "row number: #{params[:row_number]}"
        # raise "Unkown Feature"
    end

    d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
    d.draw(params[:section])
  end

  def render_section(params)
    # Calculate the required height (and width eventually) for row 2 defaulting to 100
    if params[:row_number] == 2
      exons = @thing.features.select do |f|
        f.type == 'exon'
      end
      label_height, upper_margin, lower_margin = 20, 5, 5
      params[:height] = ( exons.size * label_height ) + upper_margin + lower_margin
      params[:height] = 100 unless params[:height] >= 100
    end

    image = Image.new(params[:width], params[:height])
    coord = 10
    gap   = 5
    feature_width = 10
    params[:y1], params[:y2], params[:section] = 25, 75, image
    @thing.features.each do |feature|
      params[:x1], params[:x2] = coord, coord + feature_width
      feature.render( RenderAsPNG, params )
      coord += gap + feature_width
    end
    image
  end

  # @section.render(@format, :width => 45, :height => 100)
  def render_row(params)
    row = ImageList.new()
    # puts ""
    params[:height], params[:row_number] = 100, @thing.index

    @thing.sections.each do |section|
      features_total_width = section.size * 10
      boundries_width      = 20
      gaps_total_width     = 5 * ( section.size - 1 )
      params[:width]       = section.size > 0 ? features_total_width + boundries_width + gaps_total_width : 0
      # puts "section #{section.index}: [ feature_count : #{section.size}, section_width : #{width} ]"
      row.push( section.render( RenderAsPNG, params ) )
    end
    row.append(false)
  end

  # @row.render(@format)
  # This needs to be a bit more clever than this as what gets
  # rendered will depend on the row we are in i.e. the annotations
  # row (row 3) will only have the feature labels displayed.
  def render_grid(params)
    grid = ImageList.new()
    # puts ""
    @thing.rows.each do |row|
      # file = "row_#{row.index}.png"
      # puts "row number: #{row.index}, file name: #{file}"
      # row.render(RenderAsPNG).write("row_#{row.index}.png")
      grid.push( row.render(RenderAsPNG, params) )
    end
    # puts "NUMBER OF ROWS: #{grid.size}"
    # pp grid
    grid.append(true)
  end
end
