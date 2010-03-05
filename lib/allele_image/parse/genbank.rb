require "bio"

module AlleleImage::Parse

  # Parse a GenBank file and return a list of features
  class Genbank
    attr_reader :features

    # Do we want to enforce 1 entry per file?
    # entries  = Bio::GenBank.open( file )
    def initialize( file )
      # Retrieve the features
      features = Bio::GenBank.open( file ).next_entry.features.map do |feature|
        unless feature.qualifiers.length == 0
          name = ( feature.assoc["label"] ? feature.assoc["label"] : feature.assoc["note"] )

          # Trim the exon names.
          if feature.feature == "exon"
            name = name.match(/(\w+)$/).captures.last
          end

          # Here is our feature ...
          {
            :type  => feature.feature,
            :name  => name,
            :start => feature.locations.first.from,
            :stop  => feature.locations.first.to
          }
        end
      end

      # Sort the features
      @features = features.sort { |a,b| a[:start] <=> b[:start] }
    end
  end
end
