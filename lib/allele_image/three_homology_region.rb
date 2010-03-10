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

    def calculate_width
      AlleleImage::FiveHomologyRegion.new( @three_arm_features ).calculate_width() +
      AlleleImage::CassetteRegion.new( @loxp_region_features ).calculate_width()   +
      AlleleImage::FiveHomologyRegion.new( @target_region_features ).calculate_width()
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

      if @loxp_region_features.count > 0
        # pp [ "loxp_region_features" => @loxp_region_features, "count" => @loxp_region_features.count ]
        image.unshift( AlleleImage::CassetteRegion.new( @loxp_region_features ).render() )
      end

      if @target_region_features.count > 0
        image.unshift( AlleleImage::FiveHomologyRegion.new( @target_region_features ).render() )
      end

      image.append( false )
    end
  end
end