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
  # - what percentage of the image does it occupy i.e. height and width
  # These should all be passed in the params
  # (although the shape could be pre-determined from the feature type)
  def render_feature(params)
    # Let's stick this here so we can have at least an empty rectangle to draw
    d = Draw.new
    d.stroke("black")

    if params[:row_number] == 0
      case @thing.type
        when "genomic" then
          if params[:bounding_primers].size == 2
            # The homology arm drawn should depend on:
            # 1 - the bounding primers
            # 2 - the total number of primers
            # Essentially, there are standard images to be drawn between different
            # pairs of primers with the only variabilty being b/w D5 and D3. This
            # would be dependent on the presence of a U3 primer upstream of the D5.
            case params[:bounding_primers].map { |p| p.label }
              when ["G5", "U5"] then draw_G5_U5(d, params)
              when ["U3", "D5"] then draw_U3_D5(d, params)
              when ["D5", "D3"] then draw_D5_D3(d, params)
              when ["D3", "G3"] then draw_D3_G3(d, params)
              else
                unless ["U5", "U3"].eql?( params[:bounding_primers].map { |p| p.label } )
                  puts ""
                  pp [ "NOT HANDLED YET:", { :bounding_primers => [ params[:bounding_primers].map { |x| x.label } ] } ]
                end
            end
          end
        when "LRPCR_primer" then
          # draw_lrpcr_primer(d, params)
        else
          # puts ""
          # pp [ "NOT HANDLED YET:", { :LRPCR_primer => @thing } ]
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
    # We should have a count of the "renderable" features.
    # These would include the "exons" and "misc_features".
    params[:renderable_features] = @thing.features.select do |feature|
      [ "exon", "misc_feature" ].include?(feature.type)
    end

    params[:bounding_primers] = [ @thing.lower_primer, @thing.upper_primer ].select { |x| ! x.nil? }

    # Calculate the section width based on the longest feature label
    # This should actually be the max of longest feature label and
    # sum of feature widths. Thus far we have no way of knowing the
    # latter.
    feature_lengths = @thing.features.map do |feature|
      feature.label.nil? ? 0 : feature.label.length
    end
    max_feature_length = feature_lengths.length > 0 ? feature_lengths.max : 0

    # Furthermore x1 and y1 would depend on the section width and the
    # sum of RENDERABLE feature widths.
    # params[:x1], params[:y1] = 10, 10

    # All this should be done at Grid level
    if params[:row_number] == 2
      exons = @thing.features.select do |f|
        f.type == 'exon'
      end

      # Calculate the required height for row 2 defaulting to 100
      left_margin = ( params[:width] - ( max_feature_length * params[:text_width] ) ) / 2
      params[:lower_margin] = params[:upper_margin]

      # params[:height] = [ params[:height], ( exons.size * params[:feature_height] ) + params[:upper_margin] + params[:lower_margin] ].max

      # center the label
      params[:x1]     = left_margin
      params[:y1]     = params[:upper_margin] #( params[:height] - params[:feature_height] ) / 2
      params[:x2]     = params[:width] - left_margin
      params[:y2]     = params[:y1] + params[:feature_height]

      params[:feature_width]  = params[:x2] - params[:x1]
      params[:feature_height] = params[:text_height]
      params[:gap]            = 0

      # pp [
      #   :height => params[:height],
      #   :x1     => params[:x1],
      #   :y1     => params[:y1]
      # ]
    else
      params[:feature_width]  = 20
      params[:feature_height] = 20
      params[:gap]            = 5

      # centering the images
      feature_total_width = ( params[:feature_width] * params[:renderable_features].size ) + ( params[:gap] * ( params[:renderable_features].size - 1 ) )
      feature_total_width = 0 unless feature_total_width > 0
      params[:x1]         = ( params[:width] - feature_total_width ) / 2
      params[:y1]         = ( params[:height] - params[:feature_height] ) / 2
      params[:x2]         = params[:x1] + params[:feature_width]
      params[:y2]         = params[:y1] + params[:feature_height]
    end

    params[:section] = Image.new( params[:width], params[:height] )

    # Draw the sequence
    if params[:row_number] == 1
      # pp [ "DRAW SEQUENCE:", { :params => [ 0, params[:height] / 2, params[:width], params[:height] / 2 ] } ]
      draw_feature( d = Draw.new, params ) do
        d.stroke("black")
        d.stroke_width(2.5)
        d.line( 0, params[:height] / 2, params[:width], params[:height] / 2 )
      end
    end

    # loop through and render our features ...
    @thing.features.each do |feature|
      if feature.render( RenderAsPNG, params )
        # update the coordinates if a feature was rendered
        if params[:row_number] == 2
          params[:y1] = params[:y2] + params[:gap]
          params[:y2] = params[:y1] + params[:feature_height]
        else
          params[:x1] = params[:x2] + params[:gap]
          params[:x2] = params[:x1] + params[:feature_width]
        end
      end
    end

    # puts "\tSECTION LEVEL: [ #{params[:width]}, #{params[:height]} ]"

    params[:section]
  end

  def render_row(params)
    row = ImageList.new()
    # params[:height], params[:width], params[:row_number] = 100, 100, @thing.index
    params[:row_number] = @thing.index

    # pp [ :DEBUGGING => params ]

    @thing.sections.each do |section|
      row.push( section.render( RenderAsPNG, params ) )

      # if params[:width].nil?
      #   puts "\tROW LEVEL: [ #{params[:width]}, #{params[:height]} ]"
      #   pp [ :params => params ]
      # end
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
    params[:rcmb_primers] = @thing.rcmb_primers
    params[:text_width]   = 10
    params[:text_height]  = 20
    params[:upper_margin] = 5

    widths = []
    height = params[:text_height] + 2 * params[:upper_margin]

    @thing.rows[1].sections.each do |section|
      # redo this logic ...
      exons      = section.features.select { |f| f.type == "exon" }
      feature_labels      = exons.map { |f| f.label.nil? ? 0 : f.label.length }
      renderable_features = section.features.select { |f| [ "exon", "misc_feature" ].include?(f.type) }
      feature_total_size  = ( renderable_features.size * 20 ) + ( ( renderable_features.size - 1 ) * 5 )

      feature_labels     = params[:text_width] * ( feature_labels.length > 0 ? feature_labels.max : 0 )
      feature_total_size = 0 unless feature_total_size >= 0

      widths[ section.index ]  = [ feature_labels, feature_total_size ].max
      height = [ height, exons.size * params[:text_height] + 2 * params[:upper_margin] ].max

      # raise pp [ "WIDTH IS NIL:", { :params => params } ] if widths[ section.index ].nil?
    end

    params[:height] = 100 # need to calculate this too
    # pp [ :height => height ]

    @thing.rows.each_index do |row_index|
      params[:width]  = widths[row_index]
      params[:height] = height if row_index == 2
      # puts "height: #{ params[:height] = height }" if row_index == 2
      # puts "GRID LEVEL: [ #{params[:width]}, #{params[:height]} ]"
      grid.push( @thing.rows[row_index].render(RenderAsPNG, params) )
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
    d.annotate( params[:section], params[:feature_width], params[:feature_height], params[:x1], params[:y1], @thing.label || " " ) do
      self.fill    = "blue"
      self.gravity = CenterGravity
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

  def draw_G5_U5(d, params)
    draw_feature(d, params) do
      d.stroke_width(2.5)
      d.line( 0, params[:height] / 2 + 10,  0, params[:height] / 2 )
      d.draw(params[:section])
      d.line( 0, params[:height] / 2, params[:width] - 1, params[:height] / 2 )
      d.draw(params[:section])
      d.line( params[:width] - 1, params[:height] / 2, params[:width] - 1, params[:height] / 2 + 10 )
    end
  end

  def draw_U3_D5(d, params)
    draw_feature(d, params) do
      d.stroke_width(2.5)
      d.line( 0, params[:height] / 2 + 10,  0, params[:height] / 2 )
      d.draw(params[:section])
      d.line( 0, params[:height] / 2, params[:width] - 1, params[:height] / 2 )
    end
  end

  def draw_D3_G3(d, params)
    draw_feature(d, params) do
      d.stroke_width(2.5)
      d.line( 0, params[:height] / 2, params[:width] - 1, params[:height] / 2 )
      d.draw(params[:section])
      d.line( params[:width] - 1, params[:height] / 2, params[:width] - 1, params[:height] / 2 + 10 )
    end
  end

  def draw_D5_D3(d, params)
    if params[:rcmb_primers][2].label == "D5"
      draw_feature(d, params) do
         d.stroke_width(2.5)
         d.line( 0, params[:height] / 2 + 10,  0, params[:height] / 2 )
         d.draw(params[:section])
         d.line( 0, params[:height] / 2, params[:width] - 1, params[:height] / 2 )
       end
     else
       draw_feature(d, params) do
          d.stroke_width(2.5)
          d.line( 0, params[:height] / 2, params[:width] - 1, params[:height] / 2 )
        end
    end
  end

  def draw_lrpcr_primer(d, params)
    draw_feature(d, params) do
      d.stroke("blue")
      d.stroke_width(2)
      d.line( params[:x1], ( params[:height] / 2 ), params[:x1] + 10, ( params[:height] / 2 ) )
      d.draw( params[:section] )
      d.line( params[:x1] + 8, ( params[:height] / 2 ) - 2, params[:x1] + 8, ( params[:height] / 2 ) )
      d.draw( params[:section] )
      d.line( params[:x1] + 8, ( params[:height] / 2 ) + 2, params[:x1] + 8, ( params[:height] / 2 ) )
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
