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
      @rcmb_primers = initialize_rcmb_primers( features )
      @features     = features
    end

    # These methods always return something
    def cassette_features; end
    def five_arm_features; end
    def three_arm_features; end

    # These would return nil depending on if the
    # Construct is an Allele or a Vector
    def backbone_features; end
    def five_flank_features; end
    def three_flank_features; end

    private
      def initialize_rcmb_primers( features )
      end
  end
end
