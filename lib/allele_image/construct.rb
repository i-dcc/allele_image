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
      @cassette_label = classify_cassette_type( cassette_label )
    end

    # These methods always return something
    def cassette_features
      @features.select do |feature|
        feature.start() >= @rcmb_primers[1].start() and \
        feature.stop()  <= @rcmb_primers[2].stop()  and \
        not [ "exon", "rcmb_primer" ].include?( feature.feature_type() )
      end
    end

    def five_arm_features
      @features.select do |feature|
        feature.start() >= @rcmb_primers[0].start() and \
        feature.stop()  <= @rcmb_primers[1].stop()
      end
    end

    def three_arm_features
      @features.select do |feature|
        feature.start() >= @rcmb_primers[2].start() and \
        feature.stop()  <= @rcmb_primers.last.stop()
      end
    end

    # These would return nil depending on if the
    # Construct is an Allele or a Vector
    def backbone_features
      return unless @circular

      # retrieve any features not within the bounds of the homology arms
      @features.select do |feature|
        feature.stop() < @rcmb_primers.first.start() or feature.start() > @rcmb_primers.last.stop()
      end
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
        features.select { |feature| feature.feature_type() == "rcmb_primer" }
      end

      def classify_cassette_type( cassette_label )
        cassette_type = "Promoterless Cassette"
        promoters     = self.cassette_features.select { |f| f.feature_type() == "promoter" }

        if promoters.size > 0
          cassette_type = "Promoter-Driven Cassette"
        end

        return "#{ cassette_type }\n(#{ cassette_label })"
      end
  end
end
