module AlleleImage
  # 
  class ThreeHomologyRegion
    include AlleleImage
    attr_reader :features
    def initialize( features )
      @features     = features
      @rcmb_primers = @features.select { |feature| feature[:type] == "rcmb_primer" }

      if @rcmb_primers.count == 2
        @three_arm_features     = @features
        @target_region_features = nil
        @loxp_region_features   = nil
      else
        @target_region_features = @features.select do |feature|
          feature[:start] >= @rcmb_primers[0][:start] and feature[:start] <= @rcmb_primers[1][:start]
        end
        @loxp_region_features = @features.select do |feature|
          feature[:start] >= @rcmb_primers[1][:start] and feature[:start] <= @rcmb_primers[2][:start] and feature[:type] == "SSR_site"
        end
        @three_arm_features = @features.select do |feature|
          feature[:start] >= @rcmb_primers[2][:start] and feature[:start] <= @rcmb_primers[3][:start]
        end
      end
    end

    # This method is currently wrong. It seems to fall over when it has to
    # deal with a 3' arm which has a loxP region. This stems from the fact
    # that the AlleleImage::FiveHomologyRegion#calculate_width returns a
    # width at least big enough to write "5 ' homology arm". So have to fix
    # both methods
    def calculate_width
      three_arm_width, loxp_region_width, target_region_width = 0, 0, 0

      if @three_arm_features and @three_arm_features.count > 0
        three_arm_width = AlleleImage::FiveHomologyRegion.new( @three_arm_features ).calculate_width()
      end

      if @loxp_region_features and @loxp_region_features.count > 0
        loxp_region_width = AlleleImage::FiveHomologyRegion.new( @loxp_region_features ).calculate_width()
      end

      if @target_region_features and @target_region_features.count > 0
        target_region_width = AlleleImage::FiveHomologyRegion.new( @target_region_features ).calculate_width()
      end

      three_arm_width + loxp_region_width + target_region_width
    end

    def calculate_height
      [
        AlleleImage::FiveHomologyRegion.new( @three_arm_features ).calculate_height(),
        AlleleImage::CassetteRegion.new( @loxp_region_features ).calculate_height(),
        AlleleImage::FiveHomologyRegion.new( @target_region_features ).calculate_height()
      ].max
    end

    def render
      image = Magick::ImageList.new

      image.push( AlleleImage::FiveHomologyRegion.new( @three_arm_features ).render() )

      if @loxp_region_features and @loxp_region_features.count > 0
        image.unshift( AlleleImage::CassetteRegion.new( @loxp_region_features ).render() )
      end

      if @target_region_features and @target_region_features.count > 0
        image.unshift( AlleleImage::FiveHomologyRegion.new( @target_region_features ).render() )
      end

      image.append( false )
    end
  end
end