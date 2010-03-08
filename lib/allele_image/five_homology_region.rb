module AlleleImage
  # FiveHomologyRegion.new( features ).write_to_file( "5_homology_arm.png" )
  # 
  # Should be able to render both the 5' and 3' arms.
  # Currently focussing on the main row only!

  class FiveHomologyRegion
    include AlleleImage
    attr_reader :height, :width

    def initialize( features )
      @features              = features
      @text_width            = 10
      @text_height           = 30
      @exons                 = @features.select { |feature| feature[:type] == "exon" }
      @width, @height        = calculate_width(), 100 # calculate_height()
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

    # draw the sequence
    def draw_sequence( x1, y1, x2, y2 )
      d = Draw.new
      d.stroke("black")
      d.stroke_width( @sequence_stroke_width )
      d.line( x1, y1, x2, y2 )
      d.draw( @image )
    end

    def draw_exon( x, y )
      exon_width, exon_height = @text_width, @text_height
      d = Draw.new
      d.stroke( "black" )
      d.fill( "yellow" )
      d.rectangle( x, y, x + exon_width, y + exon_height )
      d.draw( @image )
    end

    def render
      draw_sequence( 0, @height / 2, @width, @height / 2 )

      x = ( @width - @exons.size * @text_width ) / 2
      y = ( @height - @text_height ) / 2

      @exons.each do |exon|
        draw_exon( x, y )

        x += @text_width
      end

      return @image
    end
  end
end
