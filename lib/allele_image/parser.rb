module AlleleImage
  require "bio"
  # require "pp"

  # == SYNOPSIS
  #   construct = AlleleImage::Parser.new( INPUT, FORMAT ).construct()
  #
  # == DESCRIPTION
  # This expects you to implement a parser for FORMAT that inherits
  # from AlleleImage::Parser and implements a parse() method. This method
  # MUST return an AlleleImage::Construct object which gets assigned to
  # the AlleleImage::Parser@construct attribute.
  #
  # == NOTE
  # Any parser you write should be named AlleleImage::Parser::FORMAT and
  # it should inherit from AlleleImage::Parser.
  #
  class Parser
    attr_reader :construct

    def initialize( input )
      @construct = self.parse( input )
    end

    def parse( input )
      genbank_object = get_genbank_object( input )
      data           = File.file?( input ) ? File.read( input, :encoding => "iso8859-1" ) : input
      circular       = data.split("\n").first.match(/circular/) ? true : false

      # Retrieve the features
      features = genbank_object.features.map do |feature|
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
        extract_label( genbank_object, "cassette" ),
        extract_label( genbank_object, "backbone" ),
        extract_label( genbank_object, "target_bac" )
      )
    end

    private
      def get_genbank_object( input )
        if File.file?( input )
          Bio::GenBank.new( File.read( input, :encoding => "iso8859-1" ) )
        else
          Bio::GenBank.new( input )
        end
      end

      def extract_label( genbank_object, label )
        begin
          bioseq = genbank_object.to_biosequence
          result = bioseq.comments.split("\n").find { |x| x.match(label) }
          result = result.split(":").last.strip
        rescue
          # puts "Could not extract #{label} from GenBank file"
        end
      end
  end
end
