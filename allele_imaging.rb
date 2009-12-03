#!/usr/bin/env ruby
require 'bio'
require 'rmagick'

class AlleleImaging
  include Magick

  attr_reader :features, :input_file, :rcmb_primers, :bio_seq, :canvas

  def initialize(input_file)
    # retrieve the bio seq object -- there should be only one
    gb       = Bio::GenBank.open(input_file)
    @bio_seq = gb.next_entry

    # throw an exception if there's any left
    if gb.count > 0
      puts "error: #{ gb.count } sequences, should only be one"
    end

    # retrieve the features
    @features = @bio_seq.features

    # retrieve the primers
    @rcmb_primers = @features.select { |x| x.feature.downcase == 'rcmb_primer' }

    # create a new image
    @canvas = ImageList.new
    # @canvas.new_image(800, 400, HatchFill.new('white', 'gray90'))
  end

  def main_row_features
    @features.select { |x| x.feature.downcase != 'rcmb_primer' && x.feature.downcase != 'lrpcr_primer' && x.feature.downcase != 'genomic' }
  end

  def primer_row_features
    @features.select { |x| x.feature.downcase == 'rcmb_primer' || x.feature.downcase == 'lrpcr_primer' || x.feature.downcase == 'genomic' }
  end

  def primer(label)
    primer = @rcmb_primers.select { |x| x.assoc['label']  == label }
    if primer.count > 1
      puts 'more than one primer'
    end
    primer[0]
  end

  # def primer_location(label)
  #   primer = @rcmb_primers.select { |x| x.assoc['label']  == label }
  #   if primer.count > 1
  #     puts 'more than one primer'
  #   end
  #   primer[0].locations.first.from
  # end

  #
  # NOTE:
  # The equality check (<|>) used in the blocks below are wrong as
  # they don't correctly classify the genomic regions and primers
  # whose starts lie on the boundries. Need to decide the correct way
  # to classify these and incorporate it.
  #

  #
  # This block of methods allocates the features on row 1 into the
  # appropriate columns (I don't like the redundancy or the hard-coded
  # primer labels). For now I am referring to row 1 as annotations.
  #
  def five_flank_annotations
    primer_row_features.select { |x| x.locations.first.from < primer('G5').locations.first.from }
  end

  def five_homology_annotations
    primer_row_features.select { |x| x.locations.first.from > primer('G5').locations.first.from && x.locations.first.from < primer('U5').locations.first.from }
  end

  def cassette_annotations
    primer_row_features.select { |x| x.locations.first.from > primer('U5').locations.first.from && x.locations.first.from < primer('U3').locations.first.from }
  end

  def target_region_annotations
    primer_row_features.select { |x| x.locations.first.from > primer('U3').locations.first.from && x.locations.first.from < primer('D5').locations.first.from }
  end

  def loxP_region_annotations
    primer_row_features.select { |x| x.locations.first.from > primer('D5').locations.first.from && x.locations.first.from < primer('D3').locations.first.from }
  end

  def three_homology_annotations
    primer_row_features.select { |x| x.locations.first.from > primer('D3').locations.first.from && x.locations.first.from < primer('G3').locations.first.from }
  end

  def three_flank_annotations
    primer_row_features.select { |x| x.locations.first.from > primer('G3').locations.first.from }
  end

  #
  # This block of methods allocates the features on row 2 into the
  # appropriate columns (I don't like the redundancy or the hard-coded
  # primer labels).
  #
  def five_flank_features
    main_row_features.select { |x| x.locations.first.from < primer('G5').locations.first.from }
  end

  def five_homology_features
    main_row_features.select { |x| x.locations.first.from > primer('G5').locations.first.from && x.locations.first.from < primer('U5').locations.first.from }
  end

  def cassette_features
    main_row_features.select { |x| x.locations.first.from > primer('U5').locations.first.from && x.locations.first.from < primer('U3').locations.first.from }
  end

  def target_region_features
    main_row_features.select { |x| x.locations.first.from > primer('U3').locations.first.from && x.locations.first.from < primer('D5').locations.first.from }
  end

  def loxP_region_features
    main_row_features.select { |x| x.locations.first.from > primer('D5').locations.first.from && x.locations.first.from < primer('D3').locations.first.from }
  end

  def three_homology_features
    main_row_features.select { |x| x.locations.first.from > primer('D3').locations.first.from && x.locations.first.from < primer('G3').locations.first.from }
  end
  
  def three_flank_features
    main_row_features.select { |x| x.locations.first.from > primer('G3').locations.first.from }
  end

  #
  # lets prototype the sections on the canvas
  # each section corresponds to an image in our image list
  #
  def draw_section(features)
    image = Image.new(200, 100)
    self.add_backbone(0,50,200,50).draw(image)
    ori = 10
    features.each { |x|
      self.add_exon( ori, 25, ori + 25, 75 ).draw(image)
      ori += 35
    }
    return image
  end

  def add_backbone(x1, y1, x2, y2)
    seq = Draw.new
    seq.stroke('black')
    seq.stroke_width(5)
    seq.line(x1, y1, x2, y2)
  end

  def add_exon(x1, y1, x2, y2)
    rect = Draw.new
    rect.fill('yellow')
    rect.stroke('black')
    rect.rectangle(x1, y1, x2, y2)
  end

  def draw_image(file)
    # Draw the individual sections with the given features
    @canvas.push( self.draw_section(five_flank_features) )
    @canvas.push( self.draw_section(five_homology_features) )
    @canvas.push( self.draw_section(cassette_features) )
    @canvas.push( self.draw_section(target_region_features) )
    @canvas.push( self.draw_section(loxP_region_features) )
    @canvas.push( self.draw_section(three_homology_features) )
    @canvas.push( self.draw_section(three_flank_features) )

    canvas = @canvas.append(false)
    canvas.write(file)
  end

end


# class Section
#   attr_reader :x1, :y1, :x2, :y2, :features

#   def initialize( x1, y1, x2, y2, features )
#     @x1 = x1
#     @x2 = x2
#     @y1 = y1
#     @y2 = y2
#     @features = features
#   end

#   def add_to_canvas(canvas)
#     section = Draw.new
#     section.stroke('black')
#     section.fill('white')
#     section.rectangle(@x1, @y1, @x2, @y2)
#     section.draw(canvas)
#   end
# end

#
# Should change these into proper tests and test conditional,
# non-conditional and deletion clones.
#

ai = AlleleImaging.new('/Users/io1/Documents/allele-imaging/2009_11_27_conditional_linear.gbk')

puts "number of rcmb_primers: #{ ai.rcmb_primers.count }"
puts ai.rcmb_primers.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts "number of features: #{ ai.features.count }"
puts 'five_flank_features:'
puts ai.five_flank_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'five_homology_features:'
puts ai.five_homology_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'cassette_features:'
puts ai.cassette_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'target_region_features:'
puts ai.target_region_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'loxP_region_features:'
puts ai.loxP_region_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'three_homology_features:'
puts ai.three_homology_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'three_flank_features:'
puts ai.three_flank_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }

puts 'primer_row_features:'
puts ai.primer_row_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'five_flank_annotations:'
puts ai.five_flank_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'five_homology_annotations:'
puts ai.five_homology_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'cassette_annotations:'
puts ai.cassette_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'target_region_annotations:'
puts ai.target_region_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'loxP_region_annotations:'
puts ai.loxP_region_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'three_homology_annotations:'
puts ai.three_homology_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
puts 'three_flank_annotations:'
puts ai.three_flank_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }

puts 'testing drawing:'
ai.draw_image('ai.png')
