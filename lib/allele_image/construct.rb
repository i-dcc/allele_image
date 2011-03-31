module AlleleImage
  class Construct
    attr_reader :bac_label, :boundries, :circular, :features, :rcmb_primers

    def initialize( features, circular, cassette_label, backbone_label, bac_label = nil )
      @rcmb_primers   = initialize_rcmb_primers( features )
      @features       = replace_functional_units( features, AlleleImage::FUNCTIONAL_UNITS )
      @circular       = circular
      @cassette_label = cassette_label
      @backbone_label = backbone_label
      @bac_label      = bac_label

      raise "NoRcmbPrimers" unless @rcmb_primers.size > 0

      initialize_boundries
    end

    def rcmb_primers_in(section)
      rcmb_primers.values_at(boundries[section][0], boundries[section][1])
    end

    def cassette_label
      cassette_type   = "Promoterless Cassette"
      promoters       = cassette_features.select { |feature| feature.feature_type() == "promoter" }
      cassette_type   = "Promoter-Driven Cassette" if promoters.size > 0
      @cassette_label = "#{ cassette_type }\n(#{ @cassette_label })"
    end

    # @since  0.3.4
    # @return [Array<AlleleImage::Feature>, nil]
    def backbone_features
      return unless circular
      return @backbone_features unless @backbone_features.nil?

      # retrieve and sort any features not within the bounds of the homology arms.
      upstream_features   = features.select { |feature| feature.start > rcmb_primers.last.stop   }
      downstream_features = features.select { |feature| feature.stop  < rcmb_primers.first.start }

      # reverse the order of the features in each list ... independently!
      [ upstream_features, downstream_features ].each { |feature_list| feature_list.reverse! }

      # reverse the orientation on the backbone features
      @backbone_features = [ downstream_features + upstream_features ].flatten.map do |feature|
        feature.orientation = case feature.orientation
          when "forward" then "reverse"
          when "reverse" then "forward"
          else raise "InvalidOrientation"
        end
      end
    end

    def backbone_label
      return @backbone_label unless circular

      backbone_type = "Non-DTA Containing Plasmid Backbone"
      dta_features  = backbone_features.select { |feature| feature.feature_name.match(/DTA/) }

      if dta_features.size > 0
        backbone_type = "DTA Containing Plasmid Backbone"
      end

      return "#{ backbone_type }\n(#{ @backbone_label })"
    end

    # These methods always return something
    def cassette_features
      @cassette_features ||= initialize_section(:cassette_features)
    end

    def five_arm_features
      @five_arm_features ||= initialize_section(:five_arm_features)
    end

    def three_arm_features
      @three_arm_features ||= initialize_section(:three_arm_features)
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
           ['D3', 'D5', 'G3', 'G5', 'HD', 'HU', 'U3', 'U5'].include?( feature.feature_name )
        end
      end

      def initialize_boundries
        if @rcmb_primers.count == 4
          @boundries = { :five_arm_features => [0,1], :cassette_features => [1,2], :three_arm_features => [2,3] }
        else
          @boundries = { :five_arm_features => [0,1], :cassette_features => [1,2], :three_arm_features => [2,5] }
          if cassette_features.empty?
            @cassette_features  = nil
            @boundries = { :five_arm_features => [0,2], :cassette_features => [2,3], :three_arm_features => [3,5] }
          end
        end
      end

      def initialize_section(section)
        @features.select do |f|
          f.start >= @rcmb_primers[@boundries[section][0]].start and \
          f.stop  <= @rcmb_primers[@boundries[section][1]].stop  and \
          not @rcmb_primers.map(&:feature_name).include?(f.feature_name)
        end
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
                bio_feature = Bio::Feature.new( "misc_feature", "#{start}..#{stop}" )
                bio_feature.append( Bio::Feature::Qualifier.new( "note", label ) )

                feature = AlleleImage::Feature.new( bio_feature )
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
