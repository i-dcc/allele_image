module AlleleImage
  # == SYNOPSIS
  #   construct = AlleleImage::Construct.new( features, circular, cassette_label )
  # 
  # == ATTRIBUTES
  # * features
  # * circular
  # * cassette_label
  # 
  # == METHODS
  # * cassette_features
  # * five_arm_features
  # * three_arm_features
  # 
  # The following methods may return nil
  # * backbone_features
  # * five_flank_features
  # * three_flank_features
  # 
  class Construct
    attr_reader :circular, :features, :cassette_label, :rcmb_primers

    def initialize( features, circular, cassette_label )
      @rcmb_primers   = initialize_rcmb_primers( features )
      @features       = features
      @circular       = circular
      @cassette_label = cassette_label
    end

    # These methods always return something
    def cassette_features
      @features.select do |feature|
        feature.start() >= @rcmb_primers[1].start() and \
        feature.start() <= @rcmb_primers[2].start() and \
        not [ "exon", "rcmb_primer" ].include?( feature.type() )
      end
    end

    def five_arm_features
      @features.select do |feature|
        feature.start() >= @rcmb_primers[0].start() and \
        feature.start() <= @rcmb_primers[1].start()
      end
    end

    def three_arm_features
      @features.select do |feature|
        feature.start() >= @rcmb_primers[2].start() and \
        feature.start() <= @rcmb_primers.last.start()
      end
    end

    # These would return nil depending on if the
    # Construct is an Allele or a Vector
    def backbone_features
      return unless @circular
    end

    # Not 100% sure if these should be empty if the Construct is circular
    def five_flank_features
      return if @circular
      @features.select { |feature| feature.start() < @rcmb_primers.first.start() }
    end

    def three_flank_features
      return if @circular
      @features.select { |feature| feature.start() > @rcmb_primers.last.stop() }
    end

    private
      def initialize_rcmb_primers( features )
        features.select { |feature| feature.type() == "rcmb_primer" }
      end
  end
end
