module AlleleImage
  # Definitely have to rename this class. Perhaps CASSETTE and NON_CASSETTE?
  class FiveHomologyRegion
    include AlleleImage
    attr_reader :height, :width, :features

    def initialize( features, height = 100 )
      @features              = features
      @text_width            = 10
      @text_height           = 30
      @gap_width             = 10
      @exons                 = @features.select { |feature| feature[:type] == "exon" }
      @width, @height        = calculate_width(), height # calculate_height()
      @sequence_stroke_width = 2.5

      @image = Magick::Image.new( @width, @height )
    end

    # find the longest exon label
    def calculate_width
      @exons.map { |exon| exon[:name].length } .max * @text_width
    end

    # 
    def calculate_height
      @exons.size * @text_height
    end

    def draw_exon( x, y )
      exon_width, exon_height = @text_width, @text_height
      d = Magick::Draw.new
      d.stroke( "black" )
      d.fill( "yellow" )
      d.rectangle( x, y, x + exon_width, y + exon_height )
      d.draw( @image )
    end

    def draw_intervening_sequence( x, y )
      d = Magick::Draw.new
      d.stroke( "black" )
      d.stroke_width( @sequence_stroke_width )
      d.line( x, y + @text_height, x + @text_width / 2, y )
      d.draw( @image )
      d.line( x + @text_width / 2, y + @text_height, x + @text_width, y )
      d.draw( @image )
    end

    # Return the width occupied by the exons based on the exon count
    def exon_width( count )
      count = 3 if count >= 5
      @text_width * count + @gap_width * ( count - 1 )
    end

    def render
      draw_sequence( 0, @height / 2, @width, @height / 2 )

      x = ( @width  - exon_width( @exons.count ) ) / 2
      y = ( @height - @text_height ) / 2

      features = insert_gaps_between( @exons.count >= 5 ? [ @exons.first, { :type => "intervening sequence", :name => "intervening sequence" }, @exons.last ] : @exons )

      features.each do |feature|
        feature_width = 0
        if feature[:name] == "gap"
          feature_width = @gap_width
        elsif feature[:name] == "intervening sequence"
          draw_intervening_sequence( x, y )
          feature_width = @text_width
        else
          draw_exon( x, y )
          feature_width = @text_width # or Feature#width if it exists
        end
        x += feature_width # update the x coordinate
      end

      # DRAW THE LABELS
      label_image = Magick::Image.new( self.calculate_width, self.calculate_height )
      x, y        = 0, 0
      @exons.each do |exon|
        draw_exon_label( exon, label_image, x, y )
        y += @text_height
      end

      # Stack and return the images
      Magick::ImageList.new.push( @image ).push( label_image ).append( true )
    end

    def draw_exon_label( exon, image, x, y )
      label = Magick::Draw.new
      label.stroke( "black" )
      label.fill( "white" )
      label.draw( image )
      label.annotate( image, self.calculate_width, @text_height, x, y, exon[:name] ) do
        self.fill    = "blue"
        self.gravity = CenterGravity
      end
    end
  end
end
