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

    if params[:row_number] == 0
      case @thing.type
        when "genomic"      then
          if params[:primers].size == 2 and @thing.label != "target region"
            puts ""
            pp   [ "GENOMIC:", { :feature => @thing, :params => params } ]
            draw_feature(d, params) do
              d.stroke_width(2.5)
              d.line( 0, params[:height] / 2, params[:width], params[:height] / 2 )
            end
          end
        when "LRPCR_primer" then
          # 
        else
          # puts "NOT HANDLED HERE:"
      end
    elsif params[:row_number] == 1
      # Here we should be checking the type of the feature and delegating to
      # specific methods for rendering those features.
      # All these methods should be refactored out and should be of the form:
      # Magick::Draw = render_feature(params)
      # Thus each case should look like so:
      # when "feature" then return render_feature(params)
      case @thing.type
        when "exon"         then draw_exon(d, params)
        when "misc_feature" then
          case @thing.label
            when "b-galactosidase" then draw_bgal(d, params)
            when "neo"             then draw_neo(d, params)
            when "En2 intron"      then draw_en2_sa(d, params) # should this be exon or intron?
            else
              # puts ""
              # pp   [ "UNKNOWN CASSETTE FEATURE:", { :row => params[:row_number], :feature => @thing } ]
              # raise "Unkown cassette feature"
          end
        when "SSR_site"     then
          if @thing.label.downcase == "loxp"
            draw_loxp(d, params)
          elsif @thing.label.downcase == "frt"
            draw_frt(d, params)
          else
            # puts ""
            # pp   [ "UNKNOWN SSR_site:", { :row => params[:row_number], :feature => @thing } ]
            # raise "Unkown SSR_site"
          end
        when "polyA_site"   then draw_polyA_site(d, params)
        # when "LRPCR_primer" then
        #   puts ""
        #   pp   [ "LRPCR_primer:", { :row => params[:row_number], :feature => @thing } ]
        # when "rcmb_primer" then
        #   # puts ""
        #   # pp   [ "rcmb_primer:", { :row => params[:row_number], :feature => @thing } ]
        # when "gateway"      then ""
        # when "genomic"      then
        #   puts ""
        #   pp   [ "genomic:", { :row => params[:row_number], :feature => @thing } ]
        else
          # puts ""
          # pp   [ "NO RENDER METHOD FOR FEATURE:", { :row => params[:row_number], :feature => @thing } ]
          # raise "Unkown Feature"
      end
    elsif params[:row_number] == 2
      unless @thing.label
        # puts ""
        # pp   [ "NO LABEL FOR FEATURE:", { :row => params[:row_number], :feature => @thing } ]
        # raise "Unlabelled feature"
      end
      return draw_label(d, params) if @thing.type == "exon"
    end
  end

  def render_section(params)
    # # 2010/02/11 -- DEBUGGING
    # if params[:row_number] == 0
    #   puts ""
    #   pp [ "DEBUGGING render_section():",
    #      { :row_number => params[:row_number],
    #        :features => @thing.features,
    #        :section_number => @thing.index,
    #        :primers => [ @thing.lower_primer, @thing.upper_primer ].select { |x| ! x.nil? } } ]
    # end

    params[:primers] = [ @thing.lower_primer, @thing.upper_primer ].select { |x| ! x.nil? }

    # Calculate the section width based on the longest feature label
    # This should actually be the max of longest feature label and
    # sum of feature widths. Thus far we have no way of knowing the
    # latter.
    feature_lengths = @thing.features.map do |feature|
      ( feature.label || "" ).length
    end
    params[:width] = [ params[:width], 10 * ( feature_lengths.max || 0 ) + 10 ].max

    # Furthermore x1 and y1 would depend on the section width and the
    # sum of RENDERABLE feature widths.
    params[:x1], params[:y1] = 10, 10

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
    params[:height], params[:row_number] = 100, @thing.index

    # # 2010/02/11 -- DEBUGGING
    # if params[:row_number] == 0
    #   puts ""
    #   pp   [ "DEBUGGING render_row():", { :row_number => params[:row_number], :features => @thing.features } ]
    # end

    @thing.sections.each do |section|
      # this calculation needs to be re-thought. Need to have a
      # default params[:width]
      features_total_width = section.size * 20
      boundries_width      = 20
      gaps_total_width     = 5 * ( section.size - 1 )

      # Don't understand why the following line gives me a funny image
      # Why is the old_section_width 190 in some cases (surely it should
      # be 100 or nil)?
      # TODO: Investigate this later when you start a dimensions branch.
      # # puts ""
      # # pp   [
      #   "SECTION WIDTH CALCULATIONS:",
      #   { :row_number        => params[:row_number],
      #     :section_number    => section.index,
      #     :feature_count     => section.size,
      #     :old_section_width => params[:width],
      #     :new_section_width => [ params[:width] || 100, features_total_width + boundries_width + gaps_total_width ].max } ]

      params[:width]       = [ 100, features_total_width + boundries_width + gaps_total_width ].max
      row.push( section.render( RenderAsPNG, params ) )
    end
    row.append(false)
  end

  # This needs to be a bit more clever than this as what gets
  # rendered will depend on the row we are in i.e. the annotations
  # row (row 3) will only have the feature labels displayed.
  def render_grid(params)
    grid = ImageList.new()

    # Perhaps here we should set the default dimensions of each section
    # which will subsequently get updated if need be? We can set different
    # values depending on which row we are on.
    # # pp @thing.rows[1]
    # exit

    @thing.rows.each do |row|
      grid.push( row.render(RenderAsPNG, params) )
    end
    grid.append(true)
  end

  # ------------------------------------------------------------------------
  # Methods for rendering different features
  # ------------------------------------------------------------------------
  def draw_feature(d, params)
    yield
    d.draw( params[:section] )
  end

  def draw_label(d, params)
    d.annotate( params[:section], params[:width], params[:height], params[:x1], params[:y1], @thing.label || " " ) do
      self.fill = "blue"
    end
  end

  def draw_exon(d, params)
    draw_feature(d, params) do
      d.fill("yellow")
      d.rectangle( params[:x1], params[:y1], params[:x2], params[:y2] )
    end
  end

  def draw_loxp(d, params)
    draw_feature(d, params) do
      d.fill("red")
      d.polygon( params[:x1], params[:y1], params[:x1] + params[:feature_width], params[:y1] + params[:feature_width] / 2, params[:x1], params[:y1] + params[:feature_width] )
    end
  end

  def draw_frt(d, params)
    draw_feature(d, params) do
      d.fill("green")
      d.arc( params[:x1] - params[:feature_width], params[:y1], params[:x2], params[:y2], 270, 90 )
      d.line( params[:x1], params[:y1], params[:x1], params[:y2] )
    end
  end

  def draw_polyA_site(d, params)
    draw_labelled_box(d, params) do
      params[:fill], params[:font], params[:label] = "white", "black", "pA"
    end
  end

  # Has an associated block that gets called first
  def draw_labelled_box(d, params)
    yield
    d.fill( params[:fill] )
    draw_feature(d, params) do
      d.rectangle( params[:x1], params[:y1], params[:x2], params[:y2] )
    end
    d.annotate( params[:section], params[:feature_width], params[:feature_height], params[:x1], params[:y1], params[:label] ) do
      self.fill        = params[:font]
      self.font_weight = BoldWeight
      self.gravity     = CenterGravity
    end

    # Remove these so we don't run into any problems later
    params.delete(:fill)
    params.delete(:font)
    params.delete(:label)

    return d
  end

  def draw_neo(d, params)
    draw_labelled_box(d, params) do
      params[:fill], params[:font], params[:label] = "aquamarine", "white", "neo"
    end
  end

  def draw_en2_sa(d, params)
    draw_labelled_box(d, params) do
      params[:fill], params[:font], params[:label] = "white", "black", "En2 SA"
    end
  end

  def draw_bgal(d, params)
    draw_labelled_box(d, params) do
      params[:fill], params[:font], params[:label] = "blue", "white", "Bgal"
    end
  end
end
