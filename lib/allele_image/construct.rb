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
    attr_reader :backbone_features, :circular, :features, :rcmb_primers

    def initialize( features, circular, cassette_label, backbone_label )
      @rcmb_primers   = initialize_rcmb_primers( features )
      @features       = replace_functional_units( features, AlleleImage::FUNCTIONAL_UNITS )
      @circular       = circular
      @cassette_label = cassette_label
      @backbone_label = backbone_label

      raise "NoRcmbPrimers" unless @rcmb_primers.size > 0

      init_backbone_features if @circular
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

      def init_backbone_features
        # retrieve and sort any features not within the bounds of the homology arms
        upstream_features   = @features.select { |feature| feature.start() > @rcmb_primers.last.stop()   }
        downstream_features = @features.select { |feature| feature.stop()  < @rcmb_primers.first.start() }

        # reverse the orientation on the backbone
        [ downstream_features.reverse() + upstream_features.reverse() ].flatten.map do |feature|
          feature.orientation = case feature.orientation
            when "forward" then "reverse"
            when "reverse" then "forward"
            else raise "InvalidOrientation"
          end
        end

        @backbone_features = downstream_features.reverse() + upstream_features.reverse()
      end

      # Replace the functional units within the list of features
      #
      # @since  0.2.7
      # @param  [Array<AlleleImage::Feature>] the features to draw
      # @param  [Hash<Array String>]          the functional units
      # @return [Array<AlleleImage::Feature>] the features to draw
      def replace_functional_units( features, units )
        units.sort{ |a,b| b[0].size <=> a[0].size }.each do |query, label|
          features.each_index do |feature_index|
            if features[ feature_index ].feature_name == query.first
              found_query = true
              query.each_index do |query_index|
                next_feature = features[ feature_index + query_index ]
                unless next_feature && query[ query_index ] == next_feature.feature_name
                  found_query = false
                end
              end
              if found_query
                # perhaps this should be its own function?
                start   = features[ feature_index ].start
                stop    = features[ feature_index + query.size - 1 ].stop
                feature = AlleleImage::Feature.new( 'misc_feature', label, start, stop )
                features.slice!( feature_index, query.size )
                features.insert( feature_index, feature )
              end
            end
          end
        end
        return features
      end
  end
end
