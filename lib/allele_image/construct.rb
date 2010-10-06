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
    attr_reader :circular, :features, :rcmb_primers


    # TODO:
    # update the @features to account for the functional units
    def initialize( features, circular, cassette_label, backbone_label )
      @rcmb_primers   = initialize_rcmb_primers( features )
      @features       = update_functional_units_in_feature_list( features, AlleleImage::FUNCTIONAL_UNITS )
      @circular       = circular
      @cassette_label = cassette_label
      @backbone_label = backbone_label

      raise "NoRcmbPrimers" unless @rcmb_primers.size > 0
    end

    def cassette_label
      cassette_type = "Promoterless Cassette"
      promoters     = cassette_features.select { |f| f.feature_type() == "promoter" }

      if promoters.size > 0
        cassette_type = "Promoter-Driven Cassette"
      end

      return "#{ cassette_type }\n(#{ @cassette_label })"
    end

    def backbone_label
      return @backbone_label unless @circular

      backbone_type = "Non-DTA Containing Plasmid Backbone"
      dta_features  = backbone_features.select { |x| x.feature_name.match(/DTA/) }

      if dta_features.size > 0
        backbone_type = "DTA Containing Plasmid Backbone"
      end

      return "#{ backbone_type }\n(#{ @backbone_label })"
    end

    # These methods always return something
    def cassette_features
      @features.select do |feature|
        feature.start() > @rcmb_primers[1].stop()  and \
        feature.stop()  < @rcmb_primers[2].start() and \
        feature.feature_type != "primer_bind"
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

      # retrieve and sort any features not within the bounds of the homology arms
      upstream_features   = @features.select { |feature| feature.start() > @rcmb_primers.last.stop()   }
      downstream_features = @features.select { |feature| feature.stop()  < @rcmb_primers.first.start() }

      return downstream_features.reverse() + upstream_features.reverse()
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
        features.select do |feature|
          feature.feature_type == 'primer_bind' and \
           ['D3', 'D5', 'G3', 'G5', 'U3', 'U5'].include?( feature.feature_name )
        end
      end

      def find_functional_unit_in_feature_list( unit, list )
        start_index = list.index( unit.first )
        return unless start_index
        return [ start_index, unit.size ] if list.slice( start_index, unit.size ) == unit
      end

      def update_functional_units_in_feature_list( features, functional_units )
        feature_labels = features.map { |feature| feature.feature_name }
        functional_units.each_pair do |unit, label|
          if slice_args = find_functional_unit_in_feature_list( unit, feature_labels )
            # we want to create a feature from the start of the first
            # feature to end of the last feature in our functional unit
            start = features[ slice_args.first ].start
            stop  = features[ slice_args.first + slice_args.last - 1 ].stop
            features.slice!( slice_args.first, slice_args.last )
            features.insert( slice_args.first, AlleleImage::Feature.new( 'misc_feature', label, start, stop ) )
          end
        end
        return features
      end
  end
end
