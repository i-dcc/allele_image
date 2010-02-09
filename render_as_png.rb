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
        # raise "Unlabelled feature"
      end
      return d.annotate( params[:section], params[:width], params[:height], params[:x1], params[:y1], @thing.label || " " )
    end

    # Here we should be checking the type of the feature and delegating to
    # specific methods for rendering those features.
    case @thing.type
      when "exon" then
        d.fill("yellow")
        d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
      when "misc_feature" then
        d.fill("red")
        d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
      when "SSR_site" then
        if @thing.label.downcase == "loxp"
          d.fill("red")
          d.stroke("black")
          x2 = params[:x1] + 25
          y2 = params[:y1] + 25
          x3 = x2 - 25 # same as x1
          y3 = y2 + 25
          d.polygon(params[:x1], params[:y1], x2, y2, x3, y3)
        elsif @thing.label.downcase == "frt"
          d.fill("green")
          d.stroke("black")
          x2 = params[:x1] + 50
          y2 = params[:y1] + 50
          d.arc(params[:x1], params[:y1], x2, y2, 270, 90)
        end
      when "polyA_site" then
        d.fill("green")
        d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
      when "LRPCR_primer" then
        d.fill("violet")
        d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
      when "gateway" then
        d.fill("black")
        d.rectangle(params[:x1], params[:y1], params[:x2], params[:y2])
      else
        puts "cannot handle this feature:"
        pp @thing
        puts "row number: #{params[:row_number]}"
        # raise "Unkown Feature"
    end

    d.draw(params[:section])
  end

  def render_section(params)
    params[:x1], params[:y1] = 10, 10

    # Calculate the section width based on the longest feature label
    # This should actually be the max of longest feature label and
    # sum of feature widths. Thus far we have no way of knowing the
    # latter. Furthermore x1 and y1 would depend on the section width
    # and the sum of feature widths.
    feature_lengths = @thing.features.map do |feature|
      ( feature.label || "" ).length
    end
    params[:width] = [ params[:width], 10 * ( feature_lengths.max || 0 ) + 10 ].max

    if params[:row_number] == 2
      params[:feature_width]  = 80
      params[:feature_height] = 20
      params[:gap]            = 0
      params[:x2]             = params[:x1] + params[:feature_width]
      params[:y2]             = params[:y1] + params[:feature_height]

      exons = @thing.features.select do |f|
        f.type == 'exon'
      end

      # Calculate the required height for row 2 defaulting to 100
      params[:upper_margin], params[:lower_margin] = 5, 5
      params[:height] = [ params[:height], ( exons.size * params[:feature_height] ) + params[:upper_margin] + params[:lower_margin] ].max
    else
      params[:feature_width]  = 20
      params[:feature_height] = 20
      params[:gap]            = 5
      params[:x2]             = params[:x1] + params[:feature_width]
      params[:y2]             = params[:y1] + params[:feature_height]
    end

    params[:section] = Image.new( params[:width], params[:height] )

    # loop through our features ...
    @thing.features.each do |feature|
      feature.render( RenderAsPNG, params )

      # update the coordinates
      if params[:row_number] == 2
        params[:y1] = params[:y2] + params[:gap]
        params[:y2] = params[:y1] + params[:feature_height]
      else
        params[:x1] = params[:x2] + params[:gap]
        params[:x2] = params[:x1] + params[:feature_width]
      end
    end

    params[:section]
  end

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

  # # when row == 2 we do things a bit differently
  # def next_coord(coord, row, increment=20)
  #   if row == 2
  #     return [ coord[0], ( coord[1] + increment + 0 ) ]
  #   else
  #     return [ ( coord[0] + increment + 5 ), coord[1] ]
  #   end
  # end
end
