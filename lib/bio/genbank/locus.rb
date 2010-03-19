=begin

"LOCUS       SCU49845                5028 bp    DNA     linear   PLN 21-JUN-1999"
#<Bio::GenBank::Locus:0x12e6304
 @circular="linear",
 @date="21-JUN-1999",
 @division="PLN",
 @entry_id="SCU49845",
 @length=5028,
 @natype="DNA",
 @strand="">

=end

module Bio
  class GenBank < NCBIDB
    include Bio::NCBIDB::Common
    class Locus
      def initialize( locus_line )
        locus_components = locus_line.split(/\s+/)
        @entry_id        = locus_components[1]
        @length          = locus_components[2]
        @natype          = locus_components[4]
        @circular        = locus_components[5]
        @division        = locus_components[6]
        @date            = locus_components[7]
        @strand          = locus_components[8] || "" # not sure which value this would be
      end
    end
  end
end
