module AlleleImage
  class Parser
    attr_reader :input

    def initialize(input)
      @input = input
    end

    # Generates an AlleleImage::Construct object from the GenBank data
    #
    # @since   v0.3.4
    # @returns [AlleleImage::Construct]
    def construct
      @construct ||= parse
    end

    private

      # The GenBank data provided as a string
      #
      # @since   v0.3.4
      # @returns [String]
      def input_data
        @input_data ||= File.file?(input) ? File.read(input, :encoding => "iso8859-1") : input
      end

      # Get the GenBank data
      #
      # @since   v0.3.4
      # @returns [Bio::GenBank]
      def genbank_data
        @genbank_data ||= Bio::GenBank.new(input_data)
      end

      # Retrieve the circularity of the GenBank data
      #
      # @since   v0.3.4
      # @returns [Boolean]
      def circular?
        input_data.split("\n").first.match(/circular/) ? true : false
      end

      def cassette;   extract_label("cassette"); end
      def backbone;   extract_label("backbone"); end
      def target_bac; extract_label("target_bac"); end

      def extract_label(label)
        begin
          bioseq = genbank_data.to_biosequence
          result = bioseq.comments.split("\n").find { |x| x.match(label) }
          result = result.split(":").last.strip
        rescue
          puts "Could not extract #{label} from GenBank file"
        end
      end

      # Parse the GenBank data into an AlleleImage::Construct object
      #
      # @since   v0.3.4
      # @returns [AlleleImage::Construct]
      def parse
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

        # Sort the non-nil features
        features = features.compact.sort do |a,b|
          res = a.start <=> b.start
          res = a.stop  <=> b.stop if res == 0
          res
        end

        # Return a AlleleImage::Construct object
        AlleleImage::Construct.new(features, circular?, cassette, backbone, target_bac)
      end
  end
end
