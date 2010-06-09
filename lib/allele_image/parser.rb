module AlleleImage
  require "bio"

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
      data           = File.file?( input ) ? File.read( input ) : input
      circular       = data.split("\n").first.match(/circular/) ? true : false

      # Retrieve the features
      features = genbank_object.features.map do |feature|
        unless feature.qualifiers.length == 0
          name = ( feature.assoc["label"] ? feature.assoc["label"] : feature.assoc["note"] )

          # Trim the exon names.
          if feature.feature == "exon"
            name = name.match(/(\w+)$/).captures.last
          end

          # Here is our feature ...
          # Since creating a Feature might throw a NotRenderable exception
          # we need to wrap this in a begin/rescue block
          begin
            AlleleImage::Feature.new(
              feature.feature,
              name,
              feature.locations.first.from,
              feature.locations.first.to
            )
          rescue #NotRenderable
            # puts [ feature.feature, name ].join(",")
          end
        end
      end

      # Ignore nil features
      features = features.select { |f| not f.nil? }

      # Sort the features
      features = features.sort { |a,b| a.start <=> b.start }

      # Return a AlleleImage::Construct object
      AlleleImage::Construct.new(
        features,
        circular,
        extract_label( genbank_object, "cassette" ),
        extract_label( genbank_object, "backbone" )
      )
    end

    private
      def get_genbank_object( input )
        if File.file?( input )
          Bio::GenBank.new( File.read( input ) )
        else
          Bio::GenBank.new( input )
        end
      end

      def extract_label( genbank_object, label )
        begin
          bioseq = genbank_object.to_biosequence
          result = bioseq.comments.find { |x| x.match(label) }
          result = result.split(":").last.strip
        rescue
          # puts "Could not extract #{label} from GenBank file"
        end
      end
  end
end
