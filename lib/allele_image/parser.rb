module AlleleImage
  # A class for parsing our input data and generating a molecular construct
  #
  # @example
  #
  #   AlleleImage::Parser.new(input).construct
  #
  # @author Nelo Onyiah
  class Parser
    # Initialize a new AlleleImage::Parser object
    #
    # @since  0.3.4
    # @param  [String, File] input a string or file with GenBank data
    # @return [AlleleImage::Parser]
    def initialize(input)
      @input = input
    end

    # Generates an AlleleImage::Construct object from the GenBank data
    #
    # @since  0.3.4
    # @return [AlleleImage::Construct]
    def construct
      @construct ||= parse
    end

    private
      # The input passed into the constructor
      #
      # @since  0.3.4
      # @return (see AlleleImage::Parser#initialize)
      def input
        @input
      end

      # The GenBank data provided as a string
      #
      # @since  0.3.4
      # @return [String]
      def input_data
        @input_data ||= File.file?(input) ? File.read(input, :encoding => "iso8859-1") : input
      end

      # Get the GenBank data
      #
      # @since  0.3.4
      # @return [Bio::GenBank]
      def genbank_data
        @genbank_data ||= Bio::GenBank.new(input_data)
      end

      # Retrieve the circularity of the GenBank data
      #
      # @since  0.3.4
      # @return [Boolean]
      def circular?
        input_data.split("\n").first.match(/circular/) ? true : false
      end

      # Retrieve the cassette
      #
      # @since  0.3.4
      # @return [String]
      def cassette
        extract_label("cassette")
      end

      # Retrieve the backbone
      #
      # @since  0.3.4
      # @return [String]
      def backbone
        extract_label("backbone")
      end

      # Retrieve the target_bac
      #
      # @since  0.3.4
      # @return [String]
      def target_bac
        extract_label("target_bac")
      end

      # Extracts the requsted label from the GenBank data
      #
      # @since  0.3.4
      # @param  [String] label the label you wish to extract
      # @return [String, nil]
      def extract_label(label)
        comments = genbank_data.to_biosequence.comments
        result   = comments.split("\n").find { |x| x.match(label) } unless comments.nil?
        return result.split(":").last.strip unless result.nil?
      end

      # Parse the GenBank data into an AlleleImage::Construct object
      #
      # @since  0.3.4
      # @return [AlleleImage::Construct]
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
