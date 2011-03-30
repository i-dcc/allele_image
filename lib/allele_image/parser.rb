module AlleleImage
  class Parser
    attr_reader :construct

    def initialize( input )
      @input = File.file?(input) ? File.read( input, :encoding => "iso8859-1" ) : input
      @construct = self.parse( input )
    end

    def parse( input )
      data           = File.file?( input ) ? File.read( input, :encoding => "iso8859-1" ) : input
      circular       = data.split("\n").first.match(/circular/) ? true : false

      # Retrieve the features
      features = genbank_data.features.map do |feature|
        unless feature.qualifiers.length == 0
          # Here is our feature ...
          # Since creating a Feature might throw a NotRenderable exception
          # we need to wrap this in a begin/rescue block
          begin
            AlleleImage::Feature.new( feature )
          rescue #NotRenderable
            # puts [ feature.feature, name ].join(",")
          end
        end
      end

      # Ignore nil features
      features = features.select { |f| not f.nil? }

      # Sort the features
      features = features.sort do |a,b|
        res = a.start <=> b.start
        res = a.stop  <=> b.stop if res == 0
        res
      end

      # Return a AlleleImage::Construct object
      AlleleImage::Construct.new(
        features,
        circular,
        extract_label( genbank_data, "cassette" ),
        extract_label( genbank_data, "backbone" ),
        extract_label( genbank_data, "target_bac" )
      )
    end

    private
      # Get the GenBank data
      #
      # @since   v0.3.4
      # @returns [Bio::GenBank]
      def genbank_data
        @genbank_data ||= Bio::GenBank.new(@input)
      end

      def extract_label( genbank_data, label )
        begin
          bioseq = genbank_data.to_biosequence
          result = bioseq.comments.split("\n").find { |x| x.match(label) }
          result = result.split(":").last.strip
        rescue
          # puts "Could not extract #{label} from GenBank file"
        end
      end
  end
end
