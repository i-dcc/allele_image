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

    def initialize( construct )
      raise "NotAlleleImageConstruct" unless construct.instance_of?( AlleleImage::Construct )

      @construct   = construct
      @gap_width   = 10
      @text_width  = 10
      @text_height = 20
      @annotation_height = 70
      @sequence_stroke_width = 2.5

      @image = self.render
    end

    # The output of this method will get assigned to the @image attribute
    # of the AlleleImage::Renderer class. This is what you get when you
    # call AlleleImage::Image#render_image().
    def render
      image_list = Magick::ImageList.new()

      image_list.push( render_five_flank() )
      image_list.push( render_five_arm() )
      image_list.push( render_cassette() )
      image_list.push( render_three_arm() )
      image_list.push( render_three_flank() )

      image_list.append( false )
    end

    private
      # These methods return a Magick::Image object
      def render_cassette
        image = render_mutant_region( @construct.cassette_features(), true )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def render_five_arm
        image = render_genomic_region( @construct.five_arm_features() )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )
        genomic          = @construct.five_arm_features.select { |feature| feature.feature_type() == "genomic" }
        annotation_image = draw_homology_arm( annotation_image, genomic.last() )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def render_five_flank
        image = render_genomic_region( @construct.five_flank_features() )

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
          feature.feature_type() == "rcmb_primer"
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
            feature.feature_type() == "SSR_site"
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
        image_list.push( render_genomic_region( three_arm_features ) )

        image = image_list.append( false )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )
        genomic          = @construct.three_arm_features.select { |feature| feature.feature_type() == "genomic" }
        annotation_image = draw_homology_arm( annotation_image, genomic.last() )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def render_three_flank
        image = render_genomic_region( @construct.three_flank_features() )

        # Construct the annotation image
        image_list       = Magick::ImageList.new()
        annotation_image = Magick::Image.new( image.columns(), @annotation_height )

        # Stack the images
        image_list.push( annotation_image )
        image_list.push( image )

        return image_list.append( true )
      end

      def render_mutant_region( features, label = false )
        cassette_features = insert_gaps_between( features )
        image_list        = Magick::ImageList.new()
        image_width       = calculate_width( cassette_features )

        # Construct the main image
        image_height = 100 # again height will need to be calculated
        main_image      = Magick::Image.new( image_width, image_height )
        x               = 0
        y               = ( image_height - @text_height ) / 2 # "y" should center the images vertically
        main_image      = draw_sequence( main_image, x, image_height / 2, image_width, image_height / 2 )

        cassette_features.each do |feature|
          feature_width = 0
          if feature.feature_name() == "gap"
            feature_width = @gap_width
          else
            draw_feature( main_image, feature, x, y )
            feature_width = feature.feature_name().length * @text_width # or Feature#width if it exists
          end
          x += feature_width # update the x coordinate
        end

        # Construct the label image
        label_image = Magick::Image.new( image_width, @text_height * 2 )
        label_image = draw_label( label_image, @construct.cassette_label(), 0, 0 ) if label

        # Stack the images vertically
        image_list.push( main_image )
        image_list.push( label_image )

        return image_list.append( true )
      end

      def render_genomic_region( features )
        exons = []

        if features
          exons = features.select { |feature| feature.feature_type() == "exon" }
        end

        image_list  = Magick::ImageList.new()
        image_width = calculate_genomic_region_width( exons )

        # Construct the main image
        image_height = 100 # again height will need to be calculated
        main_image   = Magick::Image.new( image_width, image_height )
        main_image   = draw_sequence( main_image, 0, image_height / 2, image_width, image_height / 2 )

        x = ( image_width - calculate_exon_image_width( exons.count ) ) / 2
        y = ( image_height - @text_height ) / 2

        # This could be cleaner
        features = insert_gaps_between(
          exons.count >= 5 ? [ 
            exons.first,
            AlleleImage::Feature.new( "misc_feature", "intervening sequence", 1, 1 ),
            exons.last
          ] : exons )

          features.each do |feature|
            feature_width = 0
            if feature.feature_name() == "gap"
              feature_width = @gap_width
            elsif feature.feature_name() == "intervening sequence"
              draw_intervening_sequence( main_image, x, y )
              feature_width = @text_width
            else
              draw_exon( main_image, x, y )
              feature_width = @text_width # or Feature#width if it exists
            end
            x += feature_width # update the x coordinate
          end

        # Construct the label image
        label_image, x, y = Magick::Image.new( image_width, calculate_labels_image_height( exons ) ), 0, 0

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
      # Need to get this method drawing exons as well
      def draw_feature( image, feature, x, y )
        case feature.feature_name()
        when "FRT"
          draw_frt( image, x, y )
        when "loxP"
          draw_loxp( image, x, y )
        # Any non-speciall feature is probably a cassette feature
        # and can be rendered with the feature.render_options()
        else
          draw_cassette_feature( image, feature, x, y )
        end
      end

      # draw a box with a label to the correct width
      def draw_cassette_feature( image, feature, x, y, colour = "white", font = "black" )
          width  = feature.feature_name().length * @text_width
          height = @text_height
          colour = feature.render_options()[ "colour" ] || colour
          font   = feature.render_options()[ "font" ]   || font
          d      = Magick::Draw.new

          # create a block
          d.stroke( "black" )
          d.fill( colour )
          d.rectangle( x, y, x + width, y + height )
          d.draw( image )

          # annotate the block
          d.annotate( image, width, height, x, y, feature.feature_name() ) do
            self.fill        = font
            self.font_weight = Magick::BoldWeight
            self.gravity     = Magick::CenterGravity
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

        # pp [ :sequence_stroke_width => @sequence_stroke_width, :drawing => d ]

        return image
      end

      # draw the homology arms
      def draw_homology_arm( image, feature )
        d = Magick::Draw.new
        y = image.rows / 2
        w = image.columns - 1
        h = image.rows / 5 # overhang

        # Draw the lines
        d.stroke( "black" )
        d.stroke_width( 2.5 )
        d.line( 0, y + h, 0, y ).draw( image )
        d.line( 0, y, w, y ).draw( image )
        d.line( w, y, w, y + h ).draw( image )

        # We want better labels here
        label_for = { "5 arm" => "5' homology arm", "3 arm" => "3' homology arm" }

        # annotate the block
        d.annotate( image, w, y, 0, 0,
          "#{ label_for[ feature.feature_name() ] }\n(#{ feature.stop() - feature.start() } bp)" ) do
          self.fill    = "blue"
          self.gravity = Magick::CenterGravity
        end

        return image
      end

      def draw_label( image, label, x, y )
        d = Magick::Draw.new

        d.stroke( "black" )
        d.fill( "white" )
        d.draw( image )
        d.annotate( image, image.columns(), @text_height, x, y, label ) do
          self.fill    = "blue"
          self.gravity = Magick::CenterGravity
        end

        return image
      end

      def draw_loxp( image, x, y )
        feature_width = "loxP".length * @text_width
        d             = Magick::Draw.new

        d.stroke( "black" )
        d.fill( "red" )
        d.polygon( x, y, x + feature_width, y + @text_height / 2, x, y + @text_height )
        d.draw( image )

        return image
      end

      def draw_frt( image, x, y )
        feature_width = "FRT".length * @text_width
        d             = Magick::Draw.new

        d.stroke( "black" )
        d.fill( "green" )
        d.arc( x - feature_width, y, x + feature_width, y + @text_height, 270, 90 )
        d.line( x, y, x, y + @text_height )
        d.draw( image )

        return image
      end

      def draw_exon( image, x, y )
        exon_width  = @text_width
        exon_height = @text_height
        d           = Magick::Draw.new

        d.stroke( "black" )
        d.fill( "yellow" )
        d.rectangle( x, y, x + exon_width, y + exon_height )
        d.draw( image )

        return image
      end

      def draw_intervening_sequence( image, x, y )
        d = Magick::Draw.new

        d.stroke( "black" )
        d.stroke_width( @sequence_stroke_width )
        d.line( x, y + @text_height, x + @text_width / 2, y )
        d.draw( image )
        d.line( x + @text_width / 2, y + @text_height, x + @text_width, y )
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

      def calculate_labels_image_height( exons )
        exons.size * @text_height
      end

      # find sum of feature labels
      def calculate_width( features )
        width, gaps = 0, 0
        features.each do |feature|
          if feature.feature_name() == "gap"
            gaps += @gap_width
          else
            width += feature.feature_name().length * @text_width # should check/define feature.width/feature[:width] first
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

=begin From branch master:

      # Enough to write "Promoterless Cassette\n(L1L2_gt2)"
      def calculate_height
        @text_height * 2
      end
=end
