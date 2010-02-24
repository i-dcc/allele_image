#!/usr/bin/env ruby -wKU
require "rubygems"
require "pp"
require "bio"
require "feature"
require "section"
require "row"
require "grid"
require "render_as_png"

# A perl one-liner to generate the image generate commands:
# cd /nfs/users/nfs_i/io1/workspace/allele-imaging
# perl -le 'print "ruby $ARGV[2] $ARGV[1] $_" while glob "$ARGV[0]/*.gbk"' ${DATADIR} ~/tmp /nfs/users/nfs_i/io1/workspace/allele-imaging/render_allele.rb

output_dir = ARGV.shift
gbk_file   = ARGV.shift
png_file   = "#{output_dir}/mutant_allele_#{ gbk_file.match(/\d+/).to_s }.png"

# Get the features
# Parsing the GenBank is not yet complete. We need to get the is_circular flag from the GenBank file
features = Bio::GenBank.open(gbk_file).next_entry.features.map do |f|
  unless f.qualifiers.length == 0
    name = ( f.assoc["label"] ? f.assoc["label"] : f.assoc["note"] )

    # Trim the exon names. This shoud be here and not the rendering code (I think).
    if f.feature == "exon"
      name = name.match(/(\w+)$/).captures.last
    end

    Feature.new( f.feature, f.locations.first.from, f.locations.first.to, name )
  end
end

# Remove undefined values
features = features.select { |f| not f.nil? }

# Create a new grid
grid = Grid.new(features, 0).render(RenderAsPNG)

# Write the png
begin
  if grid.write(png_file)
    puts
    pp [ "SUCCESSFUL RENDERING:", { "GenBank File" => gbk_file, "Image File" => png_file } ]
  end
rescue ImageMagickError
  puts "There was an error writing to '#{png_file}'. Investigate and eliminate."
end
