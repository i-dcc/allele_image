module AlleleImage
  # 
  class ThreeHomologyRegion
    include AlleleImage
    # 
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

    def render
      image = Magick::ImageList.new

      image.push( AlleleImage::FiveHomologyRegion.new( @three_arm_features ).render() )
      image.unshift( AlleleImage::CassetteRegion.new( @loxp_region_features ).render() )       unless @loxp_region_features.nil?
      image.unshift( AlleleImage::FiveHomologyRegion.new( @target_region_features ).render() ) unless @target_region_features.nil?

      image.append( false )
    end
  end
end