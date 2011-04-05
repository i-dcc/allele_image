module AlleleImage
  class Renderer

    attr_reader :construct

    # Initialize a new AlleleImage::Renderer object
    #
    # @since  v0.3.4
    # @param  [AlleleImage::Construct] construct the construct we are going to draw
    # @param  [Hash] params optional parameters
    # @option params [Num] :bottom_margin (25)
    # @option params [Num] :feature_height (40)
    # @option params [Num] :top_margin (25)
    # @option params [Num] :font_size (18)
    # @option params [Num] :gap_width (10)
    # @option params [Num] :text_width (16)
    # @option params [Num] :text_height (22)
    # @option params [Num] :feature_height (40)
    # @option params [Num] :annotation_height (100)
    # @option params [Num] :sequence_stroke_width (2.5)
    # @return [AlleleImage::Renderer]
    def initialize( construct, params = {} )
      raise "NotAlleleImageConstruct" unless construct.instance_of?( AlleleImage::Construct )

      # assign our construct attribute
      @construct = construct

      #
      # NOTE
      # See sebs example of how to make this bit of logic more succinct
      # http://svn.internal.sanger.ac.uk/cgi-bin/viewvc.cgi/projects/htgt_to_targ_rep
      # /trunk/lib/molecular_structures.rb?revision=1679&root=htgt&view=markup
      #

      # handle the optional parameters passed in via params hash
      defaults = {
        :bottom_margin         => 25,
        :feature_height        => 40,
        :top_margin            => 25,
        :font_size             => 18,
        :gap_width             => 10,
        :text_width            => 16,
        :text_height           => 22,
        :feature_height        => 40,
        :annotation_height     => 100,
        :sequence_stroke_width => 2.5
      }
      params = defaults.update( params )

      # update the attributes from their default values
      @bottom_margin         = params[:bottom_margin]
      @feature_height        = params[:feature_height]
      @top_margin            = params[:top_margin]
      @gap_width             = params[:gap_width]
      @text_width            = params[:text_width]
      @text_height           = params[:text_height]
      @feature_height        = params[:feature_height]
      @annotation_height     = params[:annotation_height]
      @sequence_stroke_width = params[:sequence_stroke_width]
      @font_size             = params[:font_size]
      @image_height          = @bottom_margin + @feature_height + @top_margin

      # set the AlleleImage::Feature class attribute text_width
      AlleleImage::Feature.text_width(@text_width)

      return self
    end

    # Retrieves the image being generated
    #
    # @since  v0.3.4
    # @return [Magick::Image]
    def image
      @image ||= render
    end

    # Renders the cartoon image. This returns a Magick::Image image and as such
    # you can call the relevant methods on that object.
    #
    #   allele_image.render.write("allele_image.gif")
    #
    # @see AlleleImage::Renderer#image
    def render
      # Construct the main image components
      main_image = Magick::ImageList.new
      five_arm   = render_five_arm
      cassette   = render_cassette
      three_arm  = render_three_arm

      main_image.push( five_arm ).push( cassette ).push( three_arm )

      # get the width of the cassette + homology arms
      bb_width = main_image.append( false ).columns

      # Actually makes more sense to push this functionality into the
      # flank drawing code. Just check for circular/linear and draw.
      five_flank  = render_five_flank
      three_flank = render_three_flank
      main_image.unshift( five_flank )
      main_image.push( three_flank )

      main_image   = main_image.append( false )

      # Return the allele (i.e no backbone) unless this is a vector
      return main_image unless construct.circular

      # Construct the backbone components and put the two images together
      vector_image   = Magick::ImageList.new
      backbone_image = render_backbone( :width => bb_width )

      vector_image.push( main_image ).push( backbone_image )

      return vector_image.append( true )
    end

    private
      # Render the backbone of the image.
      #
      # @see AlleleImage::Renderer#image
      def render_backbone( params = {} )
        backbone_image = Magick::ImageList.new
        five_flank_bb  = draw_empty_flank("5' arm backbone")
        three_flank_bb = draw_empty_flank("3' arm backbone")

        # we want to render the "AsiSI" somewhere else
        backbone_features = construct.backbone_features.select { |feature| feature.feature_name != "AsiSI" }
        params[:width]    = [ calculate_width( backbone_features ), params[:width] ].max
        backbone          = Magick::ImageList.new

        # teeze out the PGK-DTA-pA structure making sure the only thing b/w the PGK and the pA is the DTA
        wanted, rest = backbone_features.partition { |feature| %w[pA DTA PGK].include?(feature.feature_name) }

        if wanted.empty?
          backbone.push( render_mutant_region( backbone_features, :width => params[:width] ) )
        else
          unexpected_features = backbone_features.select { |feature| feature.feature_name != "DTA" and wanted.first.start < feature.start and feature.stop < wanted.last.stop }

          raise "Unexpected features in PGK-DTA-pA structure: [#{unexpected_features.map(&:feature_name).join(', ')}]" unless unexpected_features.empty?

          rest_image   = render_mutant_region( rest,   :width => calculate_width(rest) )
          wanted_image = render_mutant_region( wanted, :width => calculate_width(wanted) )

          # create some padding between
          pad_width         = params[:width] - ( wanted_image.columns + rest_image.columns )
          pad_image_5_prime = render_mutant_region( [], :width => pad_width * 0.2 )
          pad_image_3_prime = render_mutant_region( [], :width => pad_width * 0.2 )
          pad_image_middle  = render_mutant_region( [], :width => pad_width * 0.6 )
          backbone.push(pad_image_5_prime).push(wanted_image).push(pad_image_middle).push(rest_image).push(pad_image_3_prime)
        end

        backbone = backbone.append(false)
        main_bb  = Magick::ImageList.new

        # push the main backbone image onto the image list
        main_bb.push(backbone)

        # now add the label
        if construct.backbone_label
          label_image = Magick::Image.new( backbone.columns, @text_height * 2 )
          label_image = draw_label( label_image, construct.backbone_label, 0, 0, @text_height * 2 )
          main_bb.push( label_image )
        end

        backbone_image.push( five_flank_bb ).push( main_bb.append(true) ).push( three_flank_bb )
        backbone_image = backbone_image.append( false )
  
        return backbone_image
      end

      # Render the cassette of the image
      #
      # @see AlleleImage::Renderer#image
      def render_cassette
        image = render_mutant_region( construct.cassette_features, :label => construct.cassette_label )

        # Construct the annotation image
        image_list       = Magick::ImageList.new
        annotation_image = Magick::Image.new( image.columns, @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      # Render the 5' homology arm features
      #
      # @see AlleleImage::Renderer#image
      def render_five_arm
        image = render_genomic_region( construct.five_arm_features, :width => "5' arm".length * @text_width )
        # Construct the annotation image
        image_list       = Magick::ImageList.new
        annotation_image = Magick::Image.new( image.columns, @annotation_height )
        genomic          = construct.five_arm_features.find do |feature|
          feature.feature_type == "misc_feature" and \
            ["5 arm", "target region", "3 arm"].include?( feature.feature_name )
        end

        if genomic.nil?
          rcmb_primers = construct.rcmb_primers_in(:five_arm_features)
          genomic      = AlleleImage::Feature.new(
            Bio::Feature.new(
              "misc_feature",
              "#{rcmb_primers.first.start}, #{rcmb_primers.last.stop}"
            ).append( Bio::Feature::Qualifier.new( "note", "5 arm" ) )
          )
        end

        homology_arm_label = construct.bac_label ? "5' #{ construct.bac_label }" : "5 arm"
        annotation_image = draw_homology_arm( annotation_image, homology_arm_label, genomic.stop - genomic.start )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      # Render the features in the flanking region to the 5' homology arm
      #
      # @see AlleleImage::Renderer#image
      def render_five_flank
        image = construct.circular ? draw_empty_flank("5' arm main") : render_genomic_region( construct.five_flank_features )

        # Construct the annotation image
        image_list       = Magick::ImageList.new
        annotation_image = Magick::Image.new( image.columns, @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      # Render the 3' homology arm features
      #
      # @see AlleleImage::Renderer#image
      def render_three_arm
        image_list             = Magick::ImageList.new
        rcmb_primers           = construct.rcmb_primers_in(:three_arm_features)
        three_arm_features     = []
        target_region_features = []
        loxp_region_features   = []

        if rcmb_primers.count == 2
           three_arm_features = construct.three_arm_features
        else
          target_region_features = construct.three_arm_features.select do |feature|
            feature.start >= rcmb_primers[0].start and \
            feature.start <= rcmb_primers[1].start
          end
          loxp_region_features = construct.three_arm_features.select do |feature|
            feature.start >= rcmb_primers[1].start and \
            feature.start <= rcmb_primers[2].start and \
            feature.feature_type == "misc_feature" and \
            feature.feature_name == "loxP"
          end
          three_arm_features = construct.three_arm_features.select do |feature|
            feature.start >= rcmb_primers[2].start and \
            feature.start <= rcmb_primers[3].start
          end
        end

        image_list.push(render_genomic_region(target_region_features)) unless target_region_features.empty?
        image_list.push(render_mutant_region(loxp_region_features))    unless loxp_region_features.empty?
        image_list.push(render_genomic_region(three_arm_features))     unless three_arm_features.empty?

        image = image_list.empty? ? render_genomic_region([]) : image_list.append( false )

        # For the (unlikely) case where we have nothing in the 3' arm,
        # construct an empty image with width = "3' arm".length
        homology_arm_width = "3' arm".length * @text_width
        if image.columns < homology_arm_width
          padded_image  = Magick::ImageList.new
          padding_width = ( homology_arm_width - image.columns ) / 2
          padding_image = render_genomic_region( [], :width => padding_width )
          image         = padded_image.push( padding_image ).push( image ).push( padding_image.clone ).append(false)
        end

        # Construct the annotation image
        image_list       = Magick::ImageList.new
        annotation_image = Magick::Image.new( image.columns, @annotation_height )
        genomic          = construct.three_arm_features.select do |feature|
          feature.feature_type == "misc_feature" and \
            ["5 arm", "target region", "3 arm"].include?( feature.feature_name )
        end

        if genomic.size == 0
          rcmb_primers = construct.rcmb_primers_in(:three_arm_features)
          genomic.push(
            AlleleImage::Feature.new(
              Bio::Feature.new(
                "misc_feature",
                "#{rcmb_primers.first.start}, #{rcmb_primers.last.stop}"
              ).append( Bio::Feature::Qualifier.new( "note", "3 arm" ) ) ) )
        end

        homology_arm_label = construct.bac_label ? "3' #{ construct.bac_label }" : "3 arm"
        annotation_image = draw_homology_arm( annotation_image, homology_arm_label, genomic.last.stop - genomic.first.start )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      # Render the features in the flanking region to the 3' homology arm
      #
      # @see AlleleImage::Renderer#image
      def render_three_flank
        image = construct.circular ? draw_empty_flank("3' arm main") : render_genomic_region( construct.three_flank_features )

        # Construct the annotation image
        image_list       = Magick::ImageList.new
        annotation_image = Magick::Image.new( image.columns, @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      # Render the features in a mutagenic region. This needs to centralize the features it renders.
      #
      # @see    AlleleImage::Renderer#image
      # @param  [Array<AlleleImage::Feature>] features the mutagenic features to draw
      # @param  [Hash] params optional arguments
      # @option [String] :label a label to stick below the image
      # @option [Num] :width the minimumn width required
      def render_mutant_region( features, params={} )
        params[:label]    = false unless params.include?(:label)
        cassette_features = insert_gaps_between( features )
        image_list        = Magick::ImageList.new
        image_width       = params.include?(:width) ? params[:width] : calculate_width( cassette_features )

        if params[:label] and image_width < @text_width * params[:label].length
          image_width = @text_width * params[:label].length
        end

        # Construct the main image
        image_height = @image_height
        main_image   = Magick::Image.new( image_width, image_height )
        x_coord            = 0
        y_coord            = image_height / 2
        main_image   = draw_sequence( main_image, x_coord, image_height / 2, image_width, image_height / 2 )

        # Centralize the features on the image
        features_width = calculate_width( cassette_features )
        x_coord              = ( image_width - features_width ) / 2

        cassette_features.each do |feature|
          feature_width = 0
          if feature.feature_name == "gap"
            feature_width = @gap_width
          else
            draw_feature( main_image, feature, x_coord, y_coord )
            feature_width = feature.width
          end
          x_coord += feature_width ? feature_width : 0
        end

        image_list.push( main_image )

        # Construct the label image
        if params[:label]
          label_image = Magick::Image.new( image_width, @text_height * 2 )
          label_image = draw_label( label_image, params[:label], 0, 0, @text_height * 2 )
          image_list.push( label_image )
        end

        return image_list.append( true )
      end

      # Render the features in a genomic region.
      #
      # @see    AlleleImage::Renderer#image
      # @param  [Array<AlleleImage::Feature>] features the genomic features to draw
      # @param  [Hash] params optional parameters
      # @option [Num] :width (50) the minimum width of the image
      def render_genomic_region( features, params={} )
        exons       = []
        image_width = params[:width] || 50

        if features
          exons = features.select { |feature| feature.feature_type == "exon" }
        end

        image_list  = Magick::ImageList.new

        if exons and exons.count > 0
          image_width = [ calculate_genomic_region_width( exons ), image_width ].max
        end

        # Construct the main image
        image_height = @image_height
        main_image   = Magick::Image.new( image_width, image_height )
        main_image   = draw_sequence( main_image, 0, image_height / 2, image_width, image_height / 2 )

        x_coord = ( image_width - calculate_exon_image_width( exons.count ) ) / 2
        y_coord = image_height / 2

        features             = []
        intervening_sequence = AlleleImage::Feature.new(
          Bio::Feature.new( "intervening sequence", "1..2" ).append(
              Bio::Feature::Qualifier.new( "note", "intervening sequence" ) ) )

        if exons.count >= 5
          features = insert_gaps_between( [ exons.first, intervening_sequence, exons.last ] )
        else
          features = insert_gaps_between( exons )
        end

        features.each do |feature|
          feature_width = 0
          if feature.feature_name == "gap"
            feature_width = @gap_width
          else
            draw_feature( main_image, feature, x_coord, y_coord )
            # XXX -- do we have an Exon feature? I don't think so [2010-06-11] io1
            feature_width = @text_width # or Feature#width if it exists
          end
          x_coord += feature_width # update the x coordinate
        end

        # Construct the label image
        label_image, x_coord, y_coord = Magick::Image.new( image_width, calculate_labels_image_height ), 0, 0

        # Only label target exons
        exons.each do |exon|
          if exon.feature_name.match(/^target\s+exon\s+/)
            draw_label( label_image, exon.feature_name.match(/(\w+)$/).captures.last, x_coord, y_coord )
            y_coord += @text_height
          end
        end

        # Stack the images vertically
        image_list.push( main_image )
        image_list.push( label_image )

        return image_list.append( true )
      end

      # DRAW METHODS

      # Draw an empty flank region
      #
      # @see AlleleImage::Renderer#image
      def draw_empty_flank( region, height = @image_height, width = 100 )
        # let's create the 4 points we'll need
        point_a, point_b, point_c, point_e = [], [], [], []

        # set the points based on the flank "region"
        case region
          when "5' arm main"
            point_a, point_b, point_c, point_e = [width*0.5,height], [width*0.5,height*0.5], [width*0.75,height*0.5], [width,height*0.5]
          when "3' arm main"
            point_a, point_b, point_c, point_e = [width*0.5,height], [width*0.5,height*0.5], [width*0.25,height*0.5],  [0,height*0.5]
          when "5' arm backbone"
            point_a, point_b, point_c, point_e = [width*0.5,0],      [width*0.5,height*0.5], [width*0.75,height*0.5], [width,height*0.5]
          when "3' arm backbone"
            point_a, point_b, point_c, point_e = [width*0.5,0],      [width*0.5,height*0.5], [width*0.25,height*0.5],  [0,height*0.5]
          else
            raise "Not a valid region to render: #{region}"
        end

        # draw the image
        empty_flank_image = Magick::Image.new(width, height)
        sequence_drawing = Magick::Draw.new
        sequence_drawing.stroke_width(@sequence_stroke_width)
        sequence_drawing.fill("white")
        sequence_drawing.stroke("black")
        sequence_drawing.bezier(point_a.first, point_a.last, point_b.first, point_b.last, point_c.first, point_c.last)
        sequence_drawing.line(point_c.first, point_c.last, point_e.first, point_e.last)
        sequence_drawing.draw(empty_flank_image)

        # insert the AsiSI in here somewhere
        if region.match(/5' arm/)
          asisi   = Magick::Image.new( @text_width * "AsiSI".length, height )
          asisi   = draw_sequence( asisi, 0, height/2, asisi.columns, height/2 )
          feature = construct.backbone_features.find { |feature| feature.feature_name == "AsiSI" }

          if region.match(/main/) and feature
            asisi = draw_asisi( asisi, feature, [0, height/2] )
          end

          test  = Magick::ImageList.new
          test.push(empty_flank_image).push(asisi)
          empty_flank_image = test.append(false)
        end

        return empty_flank_image if region.match(/backbone/)

        # the linker to the other curved section
        linker_image = Magick::Image.new( width, calculate_labels_image_height )
        linker = Magick::Draw.new
        linker.stroke_width(@sequence_stroke_width)
        linker.fill("white")
        linker.stroke("black")
        linker.line( width * 0.5, 0, width * 0.5, linker_image.rows )
        linker.draw(linker_image)

        # create an ImageList to stack both images
        flank_image = Magick::ImageList.new
        flank_image.push(empty_flank_image).push(linker_image)

        return flank_image.append( true )
      end

      # Draw an arrow at the point specified
      #
      # @param  [Magick::Image] image the image we are drawing on
      # @param  [Array<Num>] point the locus to draw our arrow
      # @param  [Hash] params an optional set of parameters
      # @option [String] :direction ('south') the direction the arrow points
      # @option [Num] :stroke_width (2.5) the width of the lines
      # @option [Num] :tail_height (0.1 * @image_height) the length of the arrows tail
      # @option [Num] :arm_height (0.05 * @image_height) the length of the arow head arms
      # @option [Num] :arm_width (0.025 * @image_width) the span of the arrows head arms
      # @return [Magick::Image]
      def draw_arrow( image, point, params={} )
        arrow = Magick::Draw.new
        stroke_width = params[:stroke_width] || 2.5

        # set colour and thickness of arrow
        arrow.stroke( "black" )
        arrow.stroke_width(stroke_width)

        # make the value of "point" the center (origin)
        arrow.translate( point.first, point.last )

        # rotate based on the direction
        params[:direction] = "south" unless params[:direction]
        case params[:direction]
          when "north" then arrow.rotate(  0)
          when "east"  then arrow.rotate( 90)
          when "south" then arrow.rotate(180)
          when "west"  then arrow.rotate(270)
          else raise "Not a valid direction: #{params[:direction]}"
        end

        # set the arrow dimensions
        params[:tail_height] = 0.100 * image.rows    unless params[:tail_height]
        params[:arm_height]  = 0.050 * image.rows    unless params[:arm_height]
        params[:arm_width]   = 0.025 * image.columns unless params[:arm_width]

        # draw the arrow
        # We are always drawing a south-facing arrow, the "direction"
        # takes care of rotating it to point in the right ... direction
        arrow.line(                   0, params[:tail_height], 0, 0 ) # line going down
        arrow.line(  params[:arm_width],  params[:arm_height], 0, 0 ) # line from the right
        arrow.line( -params[:arm_width],  params[:arm_height], 0, 0 ) # line from the left
        arrow.draw( image )

        return image
      end

      # Draw an AsiSI at the point specified
      #
      # @param  [Magick::Image] image the image we are drawing on
      # @param  [AlleleImage::Feature] feature the AsiSI feature
      # @param  [Array<Num>] position the coordinates to draw the AsiSI feature
      # @return [Magick::Image]
      def draw_asisi( image, feature, position )
        asisi = Magick::Draw.new

        # We draw the text "AsiSI" in a box with dimensions:
        annotation_width  = feature.width
        annotation_height = @text_height
        annotation_x      = position.first
        annotation_y      = position.last - 10 - @text_height

        # draw the AsiSI on the sequence
        pointsize = @font_size
        asisi.annotate( image, annotation_width, annotation_height, annotation_x, annotation_y, feature.feature_name ) do
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.fill        = "black"
          self.pointsize   = pointsize
          self.font_family = "Helvetica"
        end

        # Draw the arrow pointing down in the moddle of the annotation
        draw_arrow( image, [ position.first + annotation_width / 2, position.last ],
          :tail_height => 10, :arm_height => 5, :arm_width => 5 )

        return image
      end

      #
      # draw the replication origin
      def draw_ori( image, x_coord, y_coord )
        origin = Magick::Draw.new
        pointsize = @font_size

        origin.annotate( image, @text_width * "ori".length, @text_height, x_coord, y_coord - @text_height, "ori" ) do
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.fill        = "black"
          self.pointsize   = pointsize
          self.font_family = "Helvetica"
        end

        return image
      end

      # Need to get this method drawing exons as well
      def draw_feature( image, feature, x_coord, y_coord )
        if feature.feature_type == "exon" and not feature.feature_name.match(/En2/)
          draw_exon( image, x_coord, y_coord )
        elsif feature.feature_type == "promoter"
          draw_promoter( image, feature, [x_coord, y_coord] )
        else
          case feature.feature_name
          when "FRT"
            draw_frt( image, feature, x_coord, y_coord )
          when "loxP"
            draw_loxp( image, feature, x_coord, y_coord )
          when "AttP"
            draw_attp( image, feature, x_coord, y_coord )
          when "intervening sequence"
            draw_intervening_sequence( image, x_coord, y_coord )
          when "F3"
            draw_f3( image, feature, x_coord, y_coord )
          when "AsiSI"
            draw_asisi( image, feature, [x_coord, y_coord] )
          when "ori"
            draw_ori( image, x_coord, y_coord )
          when "En2 SA (ATG)"
            draw_en2_k_frame( image, feature, [x_coord, y_coord] )
          # Any non-speciall feature is probably a cassette feature
          # and can be rendered with the feature.render_options
          else
            draw_cassette_feature( image, feature, x_coord, y_coord )
          end
        end
      end

      # draw a box with a label to the correct width
      def draw_cassette_feature( image, feature, x_coord, y_coord, params = {} )
          width   = feature.width
          height  = @feature_height
          colour  = feature.render_options[ "colour" ] || params[:colour] || "white"
          font    = feature.render_options[ "font" ]   || params[:font]   || "black"
          label   = params[:label] || feature.feature_name
          drawing = Magick::Draw.new

          # create a block
          drawing.stroke( "black" )
          drawing.fill( colour )
          drawing.rectangle( x_coord, @top_margin, x_coord + width, @image_height - @bottom_margin )
          drawing.draw( image )

          # annotate the block
          pointsize = @font_size
          drawing.annotate( image, width, height, x_coord, @top_margin, label ) do
            self.fill        = font
            self.font_weight = Magick::BoldWeight
            self.gravity     = Magick::CenterGravity
            self.pointsize   = pointsize
            self.font_family = "Helvetica"
          end

          return image
      end

      # draw the sequence
      def draw_sequence( image, x_coord1, y_coord1, x_coord2, y_coord2 )
        sequence_drawing = Magick::Draw.new

        sequence_drawing.stroke( "black" )
        sequence_drawing.stroke_width( @sequence_stroke_width )
        sequence_drawing.line( x_coord1, y_coord1, x_coord2, y_coord2 )
        sequence_drawing.draw( image )

        return image
      end

      # draw the homology arms
      def draw_homology_arm( image, name, length )
        homology_arm_drawing = Magick::Draw.new
        width = image.columns - 1
        height = image.rows / 7 # overhang
        y_coord = 5 * height

        # Draw the lines
        homology_arm_drawing.stroke( "black" )
        homology_arm_drawing.stroke_width( @sequence_stroke_width )
        homology_arm_drawing.line( 0, y_coord + height, 0, y_coord ).draw( image )
        homology_arm_drawing.line( 0, y_coord, width, y_coord ).draw( image )
        homology_arm_drawing.line( width, y_coord, width, y_coord + height ).draw( image )

        # We want better labels here
        label_for = { "5 arm" => "5' arm", "3 arm" => "3' arm" }

        # annotate the block
        pointsize = @font_size
        homology_arm_drawing.annotate( image, width, y_coord, 0, 0, "#{ label_for[ name ] || name }\n(#{ length } bp)" ) do
          self.fill        = "blue"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_family = "Helvetica"
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_label( image, label, x_coord, y_coord, height = @text_height )
        label_drawing = Magick::Draw.new

        label_drawing.stroke( "black" )
        label_drawing.fill( "white" )
        label_drawing.draw( image )
        pointsize = @font_size
        label_drawing.annotate( image, image.columns, height, x_coord, y_coord, label ) do
          self.fill        = "blue"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_family = "Helvetica"
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_attp( image, feature, x_coord, y_coord, attp_drawing = Magick::Draw.new, feature_width = feature.width )
        # Draw the two triangles
        attp_drawing.stroke( "black" )
        attp_drawing.fill( "red" )
        attp_drawing.polygon( x_coord, @top_margin, x_coord + feature_width - 2, @top_margin, x_coord, @image_height - @bottom_margin - 2 )
        attp_drawing.draw( image )
        attp_drawing.stroke( "black" )
        attp_drawing.fill( "red" )
        attp_drawing.polygon( x_coord + 2, @image_height - @bottom_margin, x_coord + feature_width, @top_margin + 2, x_coord + feature_width, @image_height - @bottom_margin )
        attp_drawing.draw( image )

        # write the annotation above
        pointsize = @font_size
        attp_drawing.annotate( image, feature_width, @top_margin, x_coord, 0, feature.feature_name ) do
          self.fill        = "red"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_loxp( image, feature, x_coord, y_coord, loxp_drawing = Magick::Draw.new, feature_width = feature.width )
        # Draw the triangle
        loxp_drawing.stroke( "black" )
        loxp_drawing.fill( "#800000" )

        if feature.orientation == "forward"
          loxp_drawing.polygon( x_coord, @top_margin, x_coord + feature_width, y_coord, x_coord, @image_height - @bottom_margin )
        else
          loxp_drawing.polygon( x_coord, y_coord, x_coord + feature_width, @top_margin, x_coord + feature_width, @image_height - @bottom_margin )
        end

        loxp_drawing.draw( image )

        # write the annotation above
        pointsize = @font_size
        loxp_drawing.annotate( image, feature_width, @top_margin, x_coord, 0, feature.feature_name ) do
          self.fill        = "#800000"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_f3( image, feature, x_coord, y_coord, f3_drawing = Magick::Draw.new, feature_width = feature.width )
        x2_coord = feature.orientation == "forward" ? x_coord : x_coord + feature_width

        # Draw the triangle
        f3_drawing.stroke( "black" )
        f3_drawing.fill( "orange" )
        f3_drawing.polygon( x_coord, @top_margin, x2_coord, @image_height - @bottom_margin, x_coord + feature_width, @top_margin )
        f3_drawing.draw( image )

        # write the annotation above
        pointsize = @font_size
        f3_drawing.annotate( image, feature_width, @top_margin, x_coord, 0, "F3" ) do
          self.fill        = "orange"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      # Switch to use this when you change your coordinate system
      def draw_frt( image, feature, x_coord, y_coord, frt_drawing = Magick::Draw.new, feature_width = feature.width )
        x2_coord = feature.orientation == "forward" ? x_coord : x_coord + feature_width

        # Draw the triangle
        frt_drawing.stroke( "black" )
        frt_drawing.fill( "#008040" )
        frt_drawing.polygon( x_coord, @top_margin, x2_coord, @image_height - @bottom_margin, x_coord + feature_width, @top_margin )
        frt_drawing.draw( image )

        # write the annotation above
        pointsize = @font_size
        frt_drawing.annotate( image, feature_width, @top_margin, x_coord, 0, feature.feature_name ) do
          self.fill        = "#008040"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_exon( image, x_coord, y_coord, exon_drawing = Magick::Draw.new, feature_width = @text_width )
        exon_drawing.stroke( "black" )
        exon_drawing.fill( "#fbcf3b" )
        exon_drawing.rectangle( x_coord, @top_margin, x_coord + feature_width, @image_height - @bottom_margin )
        exon_drawing.draw( image )

        return image
      end

      # Draw the K-frame En2 SA feature
      #
      # @since  0.2.6
      # @param  [Magick::Image] the image to draw on
      # @param  [AlleleImage::Feature] the feature to draw
      # @param  [Array<Num, Num>] the point to place drawing
      # @return [Magick::Image]
      def draw_en2_k_frame( image, feature, point )
        draw_cassette_feature( image, feature, point[0], point[1], :label => "En2 SA" )

        # write the annotation above
        pointsize = @font_size * 0.75
        atg_label = Magick::Draw.new
        atg_label.annotate( image, feature.width, @top_margin, point[0], 0, "ATG" ) do
          self.fill        = "black"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      # Draw a promoter
      #
      # @since  0.2.6
      # @param  [Magick::Image] the image to draw on
      # @param  [AlleleImage::Feature] the feature to draw
      # @param  [Array<Num, Num>] the point to place drawing
      # @return [Magick::Image]
      def draw_promoter( image, feature, point )
        draw_cassette_feature( image, feature, point[0], point[1] )

        # make the dimensions constant
        tail_height = 15
        arm_height  = 5
        arm_width   = 2

        # draw the arrow above the cassette feature
        first_point  = [ point[0] + feature.width / 2, @top_margin     ]
        second_point = [ point[0] + feature.width / 2, @top_margin / 2 ]
        third_point  = [
          feature.orientation == "forward" ? second_point[0] + tail_height : second_point[0] - tail_height,
          @top_margin / 2
        ]

        drawing      = Magick::Draw.new
        stroke_width = 1

        drawing.stroke("black")
        drawing.stroke_width(stroke_width)
        drawing.line( first_point[0], first_point[1], second_point[0], second_point[1] )
        draw_arrow(
          image, third_point,
          :direction    => feature.orientation == "forward" ? "east" : "west",
          :tail_height  => tail_height,
          :arm_height   => arm_height,
          :arm_width    => arm_width,
          :stroke_width => stroke_width
        )

        drawing.draw( image )

        return image
      end

      def draw_intervening_sequence( image, x_coord, y_coord )
        sequence_drawing = Magick::Draw.new
        sequence_drawing
        sequence_drawing.stroke( "black" )
        sequence_drawing.stroke_width( @sequence_stroke_width )
        sequence_drawing.line( x_coord, @image_height - @bottom_margin, x_coord + @text_width / 2, @top_margin )
        sequence_drawing.draw( image )
        sequence_drawing.line( x_coord + @text_width / 2, @image_height - @bottom_margin, x_coord + @text_width, @top_margin )
        sequence_drawing.draw( image )

        return image
      end

      # UTILITY METHODS
      def calculate_genomic_region_width( exons )
        return 0 if exons.nil? or exons.empty?
        target_exons = exons.select { |exon| exon.feature_name.match(/^target\s+exon\s+/) }
        if target_exons.nil? or target_exons.empty?
          return calculate_exon_image_width( exons.size ) + @gap_width * 2 # for padding either side
        else
          return target_exons.map { |exon| exon.feature_name.match(/(\w+)$/).captures.last.length }.max * @text_width
        end
      end

      # Return the width occupied by the exons based on the exon count
      def calculate_exon_image_width( count )
        count = 3 if count >= 5
        @text_width * count + @gap_width * ( count - 1 )
      end

      def calculate_labels_image_height
        cassette_label_rows = 2 # in case of "cassette type\(cassette label)"
        three_arm_features  = construct.three_arm_features.select { |feature| feature.feature_type.match(/^target\s+exon\s+/) }.size

        # we want the maximum here
        [ cassette_label_rows, three_arm_features ].max * @text_height
      end

      # find sum of feature labels
      def calculate_width( features )
        width, gaps = 0, 0
        features.each do |feature|
          if feature.feature_name == "gap"
            gaps += @gap_width
          else
            width += feature.width ? feature.width : 0
          end
        end
        width = width + gaps
        return (width * 1.01).to_i # add an extra 10%
      end

      # Insert gaps around the SSR sites and between the exons
      #
      # @since  0.2.5
      # @param  [Array<AlleleImage::Feature>] list of features
      # @return [Array<AlleleImage::Feature>] list of features
      def insert_gaps_between( features )
        features_with_gaps = []
        gap_feature        = AlleleImage::Feature.new( Bio::Feature.new( "misc_feature", "1..1" ).append( Bio::Feature::Qualifier.new( "note", "gap" ) ) )

        return features_with_gaps if features.nil?

        features.each_index do |current_index|
          features_with_gaps.push( features[current_index] )
          next_index = current_index + 1
          unless features[next_index].nil?
            consecutive_names = [ features[current_index].feature_name, features[next_index].feature_name ]
            consecutive_types = [ features[current_index].feature_type, features[next_index].feature_type ]
            if consecutive_names.include?("loxP") ||
               consecutive_names.include?("FRT")  ||
               consecutive_names.include?("F3")   ||
               consecutive_names.include?("AttP") ||
               consecutive_names.include?("intervening sequence") ||
               consecutive_types.include?("exon")
              features_with_gaps.push( gap_feature )
            end
          end
        end

        return features_with_gaps
      end
  end
end
