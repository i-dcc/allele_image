module AlleleImage
  require "RMagick"
  require "pp"

  # == SYNOPSIS
  #   image = AlleleImage::Renderer.new( CONSTRUCT, FORMAT )
  #
  # == DESCRIPTION
  # This expects you to implement a renderer for FORMAT that inherits
  # from AlleleImage::Renderer and implements a render() method. This method
  # MUST accept an AlleleImage::Construct object which gets passed to your
  # AlleleImage::Renderer::FORMAT#render() method. The render() should return
  # something (not nil) that gets assigned to the AlleleImage::Renderer@image
  # attribute.
  #
  # == NOTE
  # You can get at the image via the @image attribute directly or from the
  # render() method. So it's up to you to make sure it is what you expect.
  #
  class Renderer
    attr_reader :image

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
        :font_size             => 14,
        :gap_width             => 10,
        :text_width            => 12,
        :text_height           => 20,
        :feature_height        => 40,
        :annotation_height     => 70,
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

      # render the image
      # XXX -- not quite sure why we do this here [2010-06-11] io1
      @image = self.render

      return self
    end

    # The output of this method will get assigned to the @image attribute
    # of the AlleleImage::Renderer class. This is what you get when you
    # call AlleleImage::Image#render_image().
    def render
      # Construct the main image components
      main_image = Magick::ImageList.new()
      five_arm   = render_five_arm()
      cassette   = render_cassette()
      three_arm  = render_three_arm()

      main_image.push( five_arm ).push( cassette ).push( three_arm )

      # get the width of the cassette + homology arms
      bb_width = main_image.append( false ).columns()

      # Actually makes more sense to push this functionality into the
      # flank drawing code. Just check for circular/linear and draw.
      five_flank  = render_five_flank()
      three_flank = render_three_flank()
      main_image.unshift( five_flank )
      main_image.push( three_flank )

      main_image   = main_image.append( false )
      # Return the allele (i.e no backbone) unless this is a vector
      return main_image unless @construct.circular()

      # Construct the backbone components and put the two images together
      vector_image   = Magick::ImageList.new()
      backbone_image = render_backbone( :width => bb_width )

      vector_image.push( main_image ).push( backbone_image )

      return vector_image.append( true )
    end

    def render_backbone( params = {} )
      backbone_image = Magick::ImageList.new()
      five_flank_bb  = draw_empty_flank("5' arm backbone")
      three_flank_bb = draw_empty_flank("3' arm backbone")

      # we want to render the "AsiSI" somewhere else
      backbone_features = @construct.backbone_features.select { |feature| feature.feature_name != "AsiSI" }
      params[:width]    = [ calculate_width( backbone_features ), params[:width] ].max
      backbone          = render_mutant_region( backbone_features, :width => params[:width], :label => @construct.backbone_label() )

      backbone_image.push( five_flank_bb ).push( backbone ).push( three_flank_bb )
      backbone_image = backbone_image.append( false )

      return backbone_image
    end

    private
      # These methods return a Magick::Image object
      def render_cassette
        image = render_mutant_region( @construct.cassette_features(), :label => @construct.cassette_label() )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def render_five_arm
        image = render_genomic_region( @construct.five_arm_features(), :width => "5' homology arm".length() * @text_width )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )
        genomic          = @construct.five_arm_features.find do |feature|
          feature.feature_type() == "misc_feature" and \
            ["5 arm", "target region", "3 arm"].include?( feature.feature_name )
        end
        annotation_image = draw_homology_arm( annotation_image, genomic.feature_name(), genomic.stop() - genomic.start() )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def draw_empty_flank( region, height = @image_height, width = 100 )
        # let's create the 3 points we'll need
        a, b, c, e = [], [], [], []

        # set the points based on the flank "region"
        case region
          when "5' arm main"
            a, b, c, e = [width*0.5,height], [width*0.5,height*0.5], [width*0.75,height*0.5], [width,height*0.5]
          when "3' arm main"
            a, b, c, e = [width*0.5,height], [width*0.5,height*0.5], [width*0.25,height*0.5],  [0,height*0.5]
          when "5' arm backbone"
            a, b, c, e = [width*0.5,0],      [width*0.5,height*0.5], [width*0.75,height*0.5], [width,height*0.5]
          when "3' arm backbone"
            a, b, c, e = [width*0.5,0],      [width*0.5,height*0.5], [width*0.25,height*0.5],  [0,height*0.5]
          else
            raise "Not a valid region to render: #{region}"
        end

        # draw the image
        i = Magick::Image.new(width, height)
        d = Magick::Draw.new
        d.stroke_width(@sequence_stroke_width)
        d.fill("white")
        d.stroke("black")
        d.bezier(a.first, a.last, b.first, b.last, c.first, c.last)
        d.line(c.first, c.last, e.first, e.last)
        d.draw(i)

        # insert the AsiSI in here somewhere
        if region.match(/5' arm/)
          asisi   = Magick::Image.new( @text_width * "AsiSI".length, height )
          asisi   = draw_sequence( asisi, 0, height/2, asisi.columns, height/2 )
          feature = @construct.backbone_features.find { |feature| feature.feature_name == "AsiSI" }

          if region.match(/main/) and feature
            asisi = draw_asisi( asisi, feature, [0, height/2] )
          end

          test  = Magick::ImageList.new
          test.push(i).push(asisi)
          i = test.append(false)
        end

        return i if region.match(/backbone/)

        # the linker to the other curved section
        l      = Magick::Image.new( width, calculate_labels_image_height() )
        linker = Magick::Draw.new
        linker.stroke_width(@sequence_stroke_width)
        linker.fill("white")
        linker.stroke("black")
        linker.line( width * 0.5, 0, width * 0.5, l.rows() )
        linker.draw(l)

        # create an ImageList to stack both images
        flank_image = Magick::ImageList.new()
        flank_image.push(i).push(l)

        return flank_image.append( true )
      end

      def render_five_flank
        image = @construct.circular() ? draw_empty_flank("5' arm main") : render_genomic_region( @construct.five_flank_features() )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def render_three_arm
        image_list = Magick::ImageList.new()

        rcmb_primers = @construct.three_arm_features.select do |feature|
          feature.feature_type() == "primer_bind" and \
            ['D3', 'D5', 'G3', 'G5', 'U3', 'U5'].include?( feature.feature_name )
        end

        if rcmb_primers.count == 2
           three_arm_features     = @construct.three_arm_features()
           target_region_features = nil
           loxp_region_features   = nil
        else
          target_region_features = @construct.three_arm_features().select do |feature|
            feature.start() >= rcmb_primers[0].start() and \
            feature.start() <= rcmb_primers[1].start()
          end
          loxp_region_features = @construct.three_arm_features().select do |feature|
            feature.start() >= rcmb_primers[1].start() and \
            feature.start() <= rcmb_primers[2].start() and \
            feature.feature_type() == "misc_feature" and \
            feature.feature_name == "loxP"
          end
          three_arm_features = @construct.three_arm_features().select do |feature|
            feature.start() >= rcmb_primers[2].start() and \
            feature.start() <= rcmb_primers[3].start()
          end
        end

        # Add the target region
        if target_region_features and target_region_features.count() > 0
          image_list.push( render_genomic_region( target_region_features ) )
        end

        # Add the loxP region
        if loxp_region_features and loxp_region_features.count() > 0
          image_list.push( render_mutant_region( loxp_region_features ) )
        end

        # Add the rest of the three arm region
        if three_arm_features and three_arm_features.count() > 0
          image_list.push( render_genomic_region( three_arm_features ) )
        end

        image = image_list.append( false )

        # For the (unlikely) case where we have nothing in the 3' arm,
        # construct an empty image with width = "3' homology arm".length()
        if image.columns == 1
          image = render_genomic_region( @construct.three_arm_features, :width => "3' homology arm".length() * @text_width )
        end

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )
        genomic          = @construct.three_arm_features.select do |feature|
          feature.feature_type() == "misc_feature" and \
            ["5 arm", "target region", "3 arm"].include?( feature.feature_name )
        end
        annotation_image = draw_homology_arm( annotation_image, genomic.last.feature_name(), genomic.last.stop() - genomic.first.start() )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def render_three_flank
        image = @construct.circular() ? draw_empty_flank("3' arm main") : render_genomic_region( @construct.three_flank_features() )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      # This needs to centralize the features it renders
      def render_mutant_region( features, params={} )
        params[:label]    = false unless params.include?(:label)
        cassette_features = insert_gaps_between( features )
        image_list        = Magick::ImageList.new()
        image_width       = params.include?(:width) ? params[:width] : calculate_width( cassette_features )

        # The minimum width of the cassette region should be wide enough
        # to write the cassette label. In the cases where the label is
        # longer than the features we'd need to centralize the image.
        # Since we don't have that logic, I'm leaving that off for now.
        unless image_width and image_width > 0
          image_width = @text_width * params[:label].length()
        end

        # Construct the main image
        image_height = @image_height
        main_image   = Magick::Image.new( image_width, image_height )
        x            = 0
        y            = image_height / 2
        main_image   = draw_sequence( main_image, x, image_height / 2, image_width, image_height / 2 )

        # Centralize the features on the image
        features_width = calculate_width( cassette_features )
        x              = ( image_width - features_width ) / 2

        cassette_features.each do |feature|
          feature_width = 0
          if feature.feature_name() == "gap"
            feature_width = @gap_width
          else
            draw_feature( main_image, feature, x, y )
            feature_width = feature.width()
          end
          x += feature_width # update the x coordinate
        end

        # Construct the label image
        label_image = Magick::Image.new( image_width, @text_height * 2 )
        label_image = draw_label( label_image, params[:label], 0, 0, @text_height * 2 ) if params[:label]

        # Stack the images vertically
        image_list.push( main_image )
        image_list.push( label_image )

        return image_list.append( true )
      end

      def render_genomic_region( features, params={} )
        exons       = []
        image_width = params[:width] || 50

        if features
          exons = features.select { |feature| feature.feature_type() == "exon" }
        end

        image_list  = Magick::ImageList.new()

        if exons and exons.count() > 0
          image_width = [ calculate_genomic_region_width( exons ), image_width ].max
        end

        # Construct the main image
        image_height = @image_height
        main_image   = Magick::Image.new( image_width, image_height )
        main_image   = draw_sequence( main_image, 0, image_height / 2, image_width, image_height / 2 )

        x = ( image_width - calculate_exon_image_width( exons.count ) ) / 2
        y = image_height / 2

        features             = []
        intervening_sequence = AlleleImage::Feature.new(
         "intervening sequence", "intervening sequence", 1, 1 )

        if exons.count >= 5
          features = insert_gaps_between( [ exons.first, intervening_sequence, exons.last ] )
        else
          features = insert_gaps_between( exons )
        end

        features.each do |feature|
          feature_width = 0
          if feature.feature_name() == "gap"
            feature_width = @gap_width
          else
            draw_feature( main_image, feature, x, y )
            # XXX -- do we have an Exon feature? I don't think so [2010-06-11] io1
            feature_width = @text_width # or Feature#width if it exists
          end
          x += feature_width # update the x coordinate
        end

        # Construct the label image
        label_image, x, y = Magick::Image.new( image_width, calculate_labels_image_height() ), 0, 0

        exons.each do |exon|
          draw_label( label_image, exon.feature_name(), x, y )
          y += @text_height
        end

        # Stack the images vertically
        image_list.push( main_image )
        image_list.push( label_image )

        return image_list.append( true )
      end

      # DRAW METHODS

      #
      # draw an arrow at the point
      def draw_arrow( image, point, params={} )
        arrow = Magick::Draw.new

        # set colour and thickness of arrow
        arrow.stroke( "black" )
        arrow.stroke_width(2.5)

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

      #
      # prototyping rendering AsiSI
      def draw_asisi( image, feature, position )
        asisi = Magick::Draw.new

        # We draw the text "AsiSI" in a box with dimensions:
        annotation_width  = feature.width()
        annotation_height = @text_height
        annotation_x      = position.first
        annotation_y      = position.last - 10 - @text_height

        # draw the AsiSI on the sequence
        pointsize = @font_size
        asisi.annotate( image, annotation_width, annotation_height, annotation_x, annotation_y, feature.feature_name() ) do
          self.gravity     = Magick::CenterGravity
          self.fill        = "black"
          self.pointsize   = pointsize
          self.font_family = "arial"
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
          self.fill        = "black"
          self.pointsize   = pointsize
          self.font_family = "arial"
        end

        return image
      end

      # Need to get this method drawing exons as well
      def draw_feature( image, feature, x, y )
        if feature.feature_type() == "exon" and not feature.feature_name.match(/En2/)
          draw_exon( image, x, y )
        else
          case feature.feature_name()
          when "FRT"
            draw_frt( image, feature, x, y )
          when "loxP"
            draw_loxp( image, feature, x, y )
          when "AttP"
            draw_attp( image, feature, x, y )
          when "intervening sequence"
            draw_intervening_sequence( image, x, y )
          when "F3"
            draw_f3( image, feature, x, y )
          when "AsiSI"
            draw_asisi( image, feature, [x, y] )
          when "ori"
            draw_ori( image, x, y )
          # Any non-speciall feature is probably a cassette feature
          # and can be rendered with the feature.render_options()
          else
            draw_cassette_feature( image, feature, x, y )
          end
        end
      end

      # draw a box with a label to the correct width
      def draw_cassette_feature( image, feature, x, y, colour = "white", font = "black", d = Magick::Draw.new )
          width  = feature.width()
          height = @feature_height
          colour = feature.render_options()[ "colour" ] || colour
          font   = feature.render_options()[ "font" ]   || font

          # create a block
          d.stroke( "black" )
          d.fill( colour )
          d.rectangle( x, @top_margin, x + width, @image_height - @bottom_margin )
          d.draw( image )

          # annotate the block
          pointsize = @font_size
          d.annotate( image, width, height, x, @top_margin, feature.feature_name() ) do
            self.fill        = font
            self.font_weight = Magick::BoldWeight
            self.gravity     = Magick::CenterGravity
            self.pointsize   = pointsize
            self.font_family = "arial"
          end

          return image
      end

      # draw the sequence
      def draw_sequence( image, x1, y1, x2, y2 )
        d = Magick::Draw.new

        d.stroke( "black" )
        d.stroke_width( @sequence_stroke_width )
        d.line( x1, y1, x2, y2 )
        d.draw( image )

        return image
      end

      # draw the homology arms
      def draw_homology_arm( image, name, length )
        d = Magick::Draw.new
        y = image.rows / 2
        w = image.columns - 1
        h = image.rows / 5 # overhang

        # Draw the lines
        d.stroke( "black" )
        d.stroke_width( @sequence_stroke_width )
        d.line( 0, y + h, 0, y ).draw( image )
        d.line( 0, y, w, y ).draw( image )
        d.line( w, y, w, y + h ).draw( image )

        # We want better labels here
        label_for = { "5 arm" => "5' homology arm", "3 arm" => "3' homology arm" }

        # annotate the block
        pointsize = @font_size
        d.annotate( image, w, y, 0, 0,
          "#{ label_for[ name ] }\n(#{ length } bp)" ) do
          self.fill      = "blue"
          self.gravity   = Magick::CenterGravity
          self.pointsize = pointsize
        end

        return image
      end

      def draw_label( image, label, x, y, height = @text_height )
        d = Magick::Draw.new

        d.stroke( "black" )
        d.fill( "white" )
        d.draw( image )
        pointsize = @font_size
        d.annotate( image, image.columns(), height, x, y, label ) do
          self.fill      = "blue"
          self.gravity   = Magick::CenterGravity
          self.pointsize = pointsize
        end

        return image
      end

      def draw_attp( image, feature, x, y, d = Magick::Draw.new, feature_width = feature.width() )
        # Draw the two triangles
        d.stroke( "black" )
        d.fill( "red" )
        d.polygon( x, @top_margin, x + feature_width - 2, @top_margin, x, @image_height - @bottom_margin - 2 )
        d.draw( image )
        d.stroke( "black" )
        d.fill( "red" )
        d.polygon( x + 2, @image_height - @bottom_margin, x + feature_width, @top_margin + 2, x + feature_width, @image_height - @bottom_margin )
        d.draw( image )

        # write the annotation above
        pointsize = @font_size
        d.annotate( image, feature_width, @top_margin, x, 0, feature.feature_name() ) do
          self.fill        = "red"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_loxp( image, feature, x, y, d = Magick::Draw.new, feature_width = feature.width() )
        # Draw the triangle
        d.fill( "red" )

        if feature.orientation == "forward"
          d.polygon( x, @top_margin, x + feature_width, y, x, @image_height - @bottom_margin )
        else
          d.polygon( x, y, x + feature_width, @top_margin, x + feature_width, @image_height - @bottom_margin )
        end

        d.draw( image )

        # write the annotation above
        pointsize = @font_size
        d.annotate( image, feature_width, @top_margin, x, 0, feature.feature_name() ) do
          self.fill        = "red"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_f3( image, feature, x, y, d = Magick::Draw.new, feature_width = feature.width() )
        b = feature.orientation == "forward" ? x : x + feature_width

        # Draw the triangle
        d.fill( "orange" )
        d.polygon( x, @top_margin, b, @image_height - @bottom_margin, x + feature_width, @top_margin )
        d.draw( image )

        # write the annotation above
        pointsize = @font_size
        d.annotate( image, feature_width, @top_margin, x, 0, "F3" ) do
          self.fill        = "orange"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      # Switch to use this when you change your coordinate system
      def draw_frt( image, feature, x, y, d = Magick::Draw.new, feature_width = feature.width() )
        b = feature.orientation == "forward" ? x : x + feature_width

        # Draw the triangle
        d.fill( "green" )
        d.polygon( x, @top_margin, b, @image_height - @bottom_margin, x + feature_width, @top_margin )
        d.draw( image )

        # write the annotation above
        pointsize = @font_size
        d.annotate( image, feature_width, @top_margin, x, 0, feature.feature_name() ) do
          self.fill        = "green"
          self.gravity     = Magick::CenterGravity
          self.font_weight = Magick::BoldWeight
          self.font_style  = Magick::ItalicStyle
          self.pointsize   = pointsize
        end

        return image
      end

      def draw_exon( image, x, y, d = Magick::Draw.new, feature_width = @text_width )
        d.stroke( "black" )
        d.fill( "yellow" )
        d.rectangle( x, @top_margin, x + feature_width, @image_height - @bottom_margin )
        d.draw( image )

        return image
      end

      def draw_intervening_sequence( image, x, y )
        d = Magick::Draw.new

        d.stroke( "black" )
        d.stroke_width( @sequence_stroke_width )
        d.line( x, @image_height - @bottom_margin, x + @text_width / 2, @top_margin )
        d.draw( image )
        d.line( x + @text_width / 2, @image_height - @bottom_margin, x + @text_width, @top_margin )
        d.draw( image )

        return image
      end

      # UTILITY METHODS
      def calculate_genomic_region_width( exons )
        characters = 0 # "5' homology arm".length
        if exons and exons.count > 0
         characters = exons.map { |exon| exon.feature_name().length() } .max
        end
        characters * @text_width
      end

      # Return the width occupied by the exons based on the exon count
      def calculate_exon_image_width( count )
        count = 3 if count >= 5
        @text_width * count + @gap_width * ( count - 1 )
      end

      def calculate_labels_image_height
        cassette_label_rows = 2 # "cassette type\(cassette label)"
        five_arm_features   = @construct.five_arm_features.select  { |f| f.feature_type == "exon" }.size
        three_arm_features  = @construct.three_arm_features.select { |f| f.feature_type == "exon" }.size
        [ cassette_label_rows, five_arm_features, three_arm_features ].max * @text_height
      end

      # find sum of feature labels
      def calculate_width( features )
        width, gaps = 0, 0
        features.each do |feature|
          if feature.feature_name() == "gap"
            gaps += @gap_width
          else
            width += feature.width()
          end
        end
        # # This will "fix" the NorCoMM allelles but it does throw off the boundries
        # # of the cassette region, so we will ignore this for now
        # unless @cassette_label.nil?
        # return [ width + gaps, @cassette_label.length * @text_width ].max
        # end
        return width + gaps
      end

      # decide on the need for a gap/space. we need one:
      # + after each SSR_site unless its the last feature in the cassette region
      # + before each SSR_site unless its the first feature in the cassette region
      #
      # == TODO
      # Because of the way the NorCoMM GenBank files are defined,
      # we will have to either:
      # -- change this method
      # -- change the GenBank files
      def insert_gaps_between( features )
        features_with_gaps = []
        gap_feature        = AlleleImage::Feature.new( "misc_feature", "gap", 1, 1 )
        previous_feature   = nil

        return features_with_gaps unless features

        features.each do |feature|
          unless previous_feature.nil?
            case [ previous_feature.feature_type(), feature.feature_type() ]
            # need a way to say [ "SSR_site", "whatever" ]
            when [ "SSR_site", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "SSR_site", "misc_feature" ]
              features_with_gaps.push( gap_feature )
            when [ "SSR_site", "polyA_site" ]
              features_with_gaps.push( gap_feature )
            when [ "SSR_site", "promoter" ]
              features_with_gaps.push( gap_feature )
            when [ "misc_feature", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "polyA_site", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "promoter", "SSR_site" ]
              features_with_gaps.push( gap_feature )
            when [ "exon", "exon" ]
              features_with_gaps.push( gap_feature )
            when [ "exon", "intervening sequence" ]
              features_with_gaps.push( gap_feature )
            when [ "intervening sequence", "exon" ]
              features_with_gaps.push( gap_feature )
            else
              # do nothing
            end
          end

          features_with_gaps.push( feature )
          previous_feature = feature
        end

        return features_with_gaps
      end
  end
end
