module AlleleImage
  # 
  class ThreeHomologyRegion
    include AlleleImage
    # 
    def initialize( features )
      @features     = features
      @rcmb_primers = @features.select { |feature| feature[:type] == "rcmb_primer" }
    end

    def render
      image = Magick::ImageList.new

      if @rcmb_primers.count == 2
        image.push( AlleleImage::FiveHomologyRegion.new( @features ).render() )
      else
        image.push( AlleleImage::FiveHomologyRegion.new(
          @features.select do |feature|
            feature[:start] >= @rcmb_primers[0][:start] and feature[:start] <= @rcmb_primers[1][:start]
          end
        ).render() )
        image.push( AlleleImage::CassetteRegion.new(
          @features.select do |feature|
            feature[:start] >= @rcmb_primers[1][:start] and feature[:start] <= @rcmb_primers[2][:start] and feature[:type] == "SSR_site"
          end
        ).render() )
        image.push( AlleleImage::FiveHomologyRegion.new(
          @features.select do |feature|
            feature[:start] >= @rcmb_primers[2][:start] and feature[:start] <= @rcmb_primers[3][:start]
          end
        ).render() )
      end

      image.append( false )
    end
  end
end