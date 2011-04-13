module AlleleImage
  class Feature
    class NotRenderableError < RuntimeError; end

    @@text_width = 12

    def Feature.text_width(new_width)
      @@text_width = new_width
    end

    attr_reader   :feature_type, :feature_name, :start, :stop, :render_options
    attr_accessor :orientation

    def initialize(bio_feature)
      @feature_type = bio_feature.feature

      note = bio_feature.to_hash['note']
      @feature_name = note[0] if note

      @position = bio_feature.position

      init_orientation
      init_start_and_stop

      unless renderable_feature?
        raise NotRenderableError, [@feature_type, @feature_name, @position].inspect + ' not renderable'
      end

      return if @feature_type == "exon" and @feature_name != "En2 exon"

      @render_options = AlleleImage::RENDERABLE_FEATURES[ @feature_type ][ @feature_name ]
      @feature_name   = @render_options[ "label" ] || @feature_name
    end

    def width
      @render_options and @render_options.has_key?("width") ? @render_options[ "width" ] :  @feature_name.length * @@text_width
    end

    def renderable_feature?
      @feature_type == "exon" or
        ( AlleleImage::RENDERABLE_FEATURES[ @feature_type ] and
          AlleleImage::RENDERABLE_FEATURES[ @feature_type ][ @feature_name ] )
    end

    private
      def init_orientation
        @orientation = @position.match(/^complement/) ? "reverse" : "forward"
      end

      def init_start_and_stop
        regex     = Regexp.new(/-?\d+/)
        matchdata = regex.match(@position)
        locus     = []
        while matchdata != nil
          locus.push( matchdata[0].to_i )
          @position = matchdata.post_match
          matchdata = regex.match(@position)
        end
        @start = locus.first
        @stop  = locus.last
      end
  end
end
