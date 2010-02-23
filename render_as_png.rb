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
        # when "genomic" then
        #   if params[:bounding_primers].size == 2
        #     # The homology arm drawn should depend on:
        #     # 1 - the bounding primers
        #     # 2 - the total number of primers
        #     # Essentially, there are standard images to be drawn between different
        #     # pairs of primers with the only variabilty being b/w D5 and D3. This
        #     # would be dependent on the presence of a U3 primer upstream of the D5.
        #     case params[:bounding_primers].map { |p| p.label }
        #       when ["G5", "U5"] then draw_G5_U5(d, params)
        #       when ["U3", "D5"] then draw_U3_D5(d, params)
        #       when ["D5", "D3"] then draw_D5_D3(d, params)
        #       when ["D3", "G3"] then draw_D3_G3(d, params)
        #       else
        #         unless ["U5", "U3"].eql?( params[:bounding_primers].map { |p| p.label } )
        #           # puts ""
        #           # pp [ "NOT HANDLED YET:", { :bounding_primers => [ params[:bounding_primers].map { |x| x.label } ] } ]
        #         end
        #     end
        #   end
        when "LRPCR_primer" then
          # draw_lrpcr_primer(d, params)
        else
          # puts ""
          # pp [ "NOT HANDLED YET:", { :LRPCR_primer => @thing } ]
      end
    elsif params[:row_number] == 1
      if params[:section_index] == 6
        # puts
        # pp [
        #   "ORIGIN",
        #   { :x1 => params[:x1], :y1 => params[:y1], :section => params[:section_index],
        #     :section => params[:section], :thing => @thing }
        # ]
      end

      # Here we should be checking the type of the feature and delegating to
      # specific methods for rendering those features.
      # All these methods should be refactored out and should be of the form:
      # Magick::Draw = render_feature(params)
      # Thus each case should look like so:
      # when "feature" then return render_feature(params)
      case @thing.type
        when "exon"         then draw_exon(d, params)
        when "INTERVENING SEQUENCE" then draw_exon_cluster(d, params)
        when "misc_feature" then
          case @thing.label
            when "b-galactosidase" then draw_bgal(d, params)
            when "neo"             then draw_neo(d, params)
            when /en.*2\s+intron/i then draw_en2_sa(d, params)
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
            puts ""
            pp   [ "UNKNOWN SSR_site:", { :row => params[:row_number], :feature => @thing } ]
            # raise "Unkown SSR_site"
          end
        when "polyA_site"   then draw_polyA_site(d, params)
        else
          # puts ""
          # pp   [ "NO RENDER METHOD FOR FEATURE:", { :row => params[:row_number], :feature => @thing } ]
          # raise "Unkown Feature"
      end
    elsif params[:row_number] == 2
      unless @thing.label
        puts ""
        pp   [ "NO LABEL FOR FEATURE:", { :row => params[:row_number], :feature => @thing } ]
        # raise "Unlabelled feature"
      end
      return draw_label(d, params) if @thing.type == "exon"
    end
  end

  def render_section(params)
    # We should have a count of the "renderable" features.
    # These would include the "exons" and "misc_features".
    params[:renderable_features] = @thing.features.select do |feature|
      params[:renderable_features_types].include?(feature.type)
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

    params[:section_index] = @thing.index
    features_to_render     = params[:renderable_features]

    exons = @thing.features.select do |f|
      f.type == 'exon'
    end
    if exons.size >= 5 and params[:row_number] == 1
      require "feature"
      features_to_render = [
        exons.first,
        Feature.new("INTERVENING SEQUENCE", exons.first.stop, exons.last.start, "NA"),
        exons.last
      ]
    end

    # All this should be done at Grid level
    # I believe all the calculation of the dimensions should be done long before this point
    # (at Grid level probably) and thus no re-calculations done here.
    if params[:row_number] == 2
      # Calculate the required height for row 2 defaulting to 100
      left_margin           = ( params[:width] - ( max_feature_length * params[:text_width] ) ) / 2
      params[:lower_margin] = params[:upper_margin]

      # center the label
      params[:x1]     = left_margin
      params[:y1]     = params[:upper_margin] #( params[:height] - params[:feature_height] ) / 2
      params[:x2]     = params[:width] - left_margin
      params[:y2]     = params[:y1] + params[:feature_height]

      params[:feature_width]  = params[:x2] - params[:x1]
      params[:feature_height] = params[:text_height]
      params[:gap]            = 0
    else
      params[:gap] = 5

      # centering the images
      feature_total_width = ( params[:feature_width] * features_to_render.size ) + ( params[:gap] * ( params[:renderable_features].size - 1 ) )
      feature_total_width = 0 unless feature_total_width > 0
      params[:x1]         = ( params[:width] - feature_total_width ) / 2
      params[:y1]         = ( params[:height] - params[:feature_height] ) / 2
      params[:x2]         = params[:x1] + params[:feature_width]
      params[:y2]         = params[:y1] + params[:feature_height]

      if @thing.index == 6
        # puts
        # pp [ "WHERE DOES X1 GET SET:", {
        #   :feature_width => params[:feature_width],
        #   :renderable_features => params[:renderable_features].size,
        #   :gap => params[:gap],
        #   :feature_total_width_orig => ( params[:feature_width] * features_to_render.size ) + ( params[:gap] * ( params[:renderable_features].size - 1 ) ),
        #   :feature_total_width => feature_total_width,
        #   :section => @thing.index, :row => params[:row_number],
        #   :width => params[:width],
        #   :x1 => params[:x1], :y1 => params[:y1]
        # } ]
      end
    end

    params[:section] = Image.new( params[:width], params[:height] )

    # Draw the sequence
    if params[:row_number] == 1
      draw_feature( d = Draw.new, params ) do
        d.stroke("black")
        d.stroke_width(2.5)
        d.line( 0, params[:height] / 2, params[:width], params[:height] / 2 )
      end
    end

    if params[:x1] < 0
      # puts ""
      # pp [ "SECTION X1 < 0" => @thing ]
    end

    # loop through and render our features ...
    features_to_render.each do |feature|
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

    params[:section]
  end

  def render_row(params)
    params[:row_number] = @thing.index

    row = ImageList.new()

    @thing.sections.each do |section|
      params[:width] = params[:widths][section.index]
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
    params[:rcmb_primers]   = @thing.rcmb_primers
    params[:text_width]     = 10
    params[:text_height]    = 20
    params[:upper_margin]   = 5
    params[:feature_height] = 20
    params[:feature_width]  = 20
    params[:gap]            = 5
    params[:renderable_features_types] = [ "exon", "misc_feature", "SSR_site", "polyA_site" ]

    params[:widths] = []

    height     = params[:text_height] + 2 * params[:upper_margin]
    min_width  = 1
    min_margin = 1

    @thing.rows[1].sections.each do |section|
      exons               = section.features.select { |f| f.type == "exon" }
      feature_labels      = exons.map { |f| f.label.nil? ? 0 : f.label.length }
      renderable_features = section.features.select do |f|
        params[:renderable_features_types].include?(f.type)
      end

      feature_total_size  = ( renderable_features.size * 20 ) + ( ( renderable_features.size - 1 ) * 5 )
      feature_labels      = params[:text_width] * ( feature_labels.length > 0 ? feature_labels.max : 0 )
      feature_total_size  = 0 unless feature_total_size >= 0

      # DEBUGGING:
      if exons.size >= 5
        feature_total_size = ( params[:feature_width] * 3 ) + ( params[:gap] * 4 )
        # puts
        # pp [ :features => section.features, :width => feature_total_size ]
      end

      params[:widths][ section.index ]  = [ min_width, feature_labels, feature_total_size ].max
      height = [ height, exons.size * params[:text_height] + 2 * params[:upper_margin] ].max

      # Ensure the 5' homology arm is long enough to write "5' homology arm (length)"
      if section.index == 1 and params[:widths][section.index] == min_width
        params[:widths][section.index] = [ params[:widths][section.index], 20 * params[:text_width] ].max
      end
    end

    params[:height] = 100 # need to calculate this too

    @thing.rows.each_index do |row_index|
      params[:width]  = params[:widths][row_index]
      params[:height] = height if row_index == 2

      grid.push( @thing.rows[row_index].render(RenderAsPNG, params) )
    end
    grid = grid.append(true)

    # perhaps we can label both the homology arms here?
    # Label the 5' homology arm
    five_arm = Draw.new
    five_arm.annotate(
      grid,
      params[:widths][1],
      params[:text_height],
      params[:widths][0],
      params[:height] / 2 - params[:text_height],
      "5' homology arm (#{params[:rcmb_primers][1].stop - params[:rcmb_primers][0].start})"
    ) { self.gravity = CenterGravity }
    five_arm.stroke("black")
    five_arm.stroke_width(2.5)
    five_arm.line( params[:widths][0], params[:height]/2 + params[:height]/20, params[:widths][0], params[:height]/2 ).draw(grid)
    five_arm.line( params[:widths][0], params[:height]/2, params[:widths][1], params[:height]/2 ).draw(grid)
    five_arm.line( params[:widths][1], params[:height]/2, params[:widths][1], params[:height]/2 + params[:height]/20 ).draw(grid)

    # Label the 3' homology arm
    three_arm = Draw.new
    three_arm.annotate(
      grid,
      eval( ( params[:rcmb_primers].size == 4 ? params[:widths][3,2] : params[:widths][3,3] ).join('+') ),
      params[:text_height],
      eval( params[:widths][0,3].join('+') ),
      params[:height] / 2 - params[:text_height],
      "3' homology arm (#{params[:rcmb_primers].last.stop - params[:rcmb_primers][2].start})"
    ) { self.gravity = CenterGravity }
    three_arm.stroke("black")
    three_arm.stroke_width(2.5)
    three_arm.line( params[:widths][0,3].reduce { |a,b| a + b }, params[:height]/2 + params[:height]/20, params[:widths][0,3].reduce { |a,b| a + b }, params[:height]/2 ).draw(grid)
    three_arm.line( params[:widths][0,3].reduce { |a,b| a + b }, params[:height]/2, params[:widths][0,3].reduce { |a,b| a + b } + ( params[:rcmb_primers].size == 4 ? params[:widths][3,2] : params[:widths][3,3] ).reduce { |a,b| a + b }, params[:height]/2 ).draw(grid)
    three_arm.line( params[:widths][0,3].reduce { |a,b| a + b } + ( params[:rcmb_primers].size == 4 ? params[:widths][3,2] : params[:widths][3,3] ).reduce { |a,b| a + b }, params[:height]/2, params[:widths][0,3].reduce { |a,b| a + b } + ( params[:rcmb_primers].size == 4 ? params[:widths][3,2] : params[:widths][3,3] ).reduce { |a,b| a + b }, params[:height]/2 + params[:height]/20 ).draw(grid)

    pp [
      [ 
        # params[:widths][0,3].reduce { |a,b| a + b }, params[:height]/2 + params[:height]/20
        # eval( params[:widths][0,3] )#.join("+"), params[:height]/2 + params[:height]/20,
        # eval( params[:widths][0,3] ).join("+"), params[:height]/2
      ]
    ]

    pp [
      # params[:widths],
      grid,
      eval( ( params[:rcmb_primers].size == 4 ? params[:widths][3,2] : params[:widths][3,3] ).join('+') ),
      params[:text_height],
      eval( params[:widths][0,3].join('+') ),
      params[:height] / 2 - params[:text_height],
      "3' homology arm (#{params[:rcmb_primers].last.stop - params[:rcmb_primers][2].start})"
    ]

    grid
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

  def draw_exon_cluster(d, params)
    d.stroke_width(2.5)
    d.line( params[:x1], params[:y1] + params[:feature_height], params[:x1] + params[:feature_width] / 2, params[:y1])
    d.draw( params[:section] )
    d.line( params[:x1] + params[:feature_width] / 2, params[:y1] + params[:feature_height], params[:x1] + params[:feature_width], params[:y1] )
    d.draw( params[:section] )
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
      d.annotate(
        params[:section],
        params[:width],
        params[:text_height],
        0,
        params[:height] / 2 - params[:text_height],
        "5' homology arm (#{params[:bounding_primers].last.stop - params[:bounding_primers].first.start})"
      ) { self.gravity = CenterGravity }
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
          d.line( 0, params[:height] / 2, params[:width], params[:height] / 2 )
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
