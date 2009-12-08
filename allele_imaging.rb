#!/usr/bin/env ruby
require 'bio'
require 'rmagick'

class AlleleImaging
  include Magick

  attr_reader :features, :input_file, :rcmb_primers, :bio_seq, :canvas, :show_all

  def initialize(input_file)
    # retrieve the bio seq object -- there should be only one
    gb       = Bio::GenBank.open(input_file)
    @bio_seq = gb.next_entry

    # throw an exception if there's any left
    if gb.count > 0
      raise "error: #{ gb.count } sequences, should only be one"
    end

    # retrieve and sort the features
    @features = @bio_seq.features.sort { |a,b| a.locations.first.from <=> b.locations.first.from }

    #
    # TODO:
    # Subset the features only keeping those we are capable of/interested in rendering
    #

    # retrieve the primers
    @rcmb_primers = @features.select { |x| x.feature.downcase == 'rcmb_primer' }

    # create a new image
    @canvas = ImageList.new
  end

  def main_row_features
    @features.select { |x| x.feature.downcase != 'rcmb_primer' && x.feature.downcase != 'lrpcr_primer' && x.feature.downcase != 'genomic' && x.feature.downcase != "primer_bind" }
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
  # each section should be a class with an to_image method
  #
  #   Section.new( features [, width = features.count * factor, height = 100 ] ).to_image -> Magick::Image
  #
  def draw_section(features)
    section_width = self.calc_width(features.count)
    image         = Image.new( section_width, 100 )
    ori           = 10

    self.add_backbone(0,50,section_width,50).draw(image)

    # puts "there are #{features.count} in section( #{section_width}, 100 )"

    features.each { |x|
      # puts "{ #{x.feature} : #{x.assoc['label']} }"

      # Handle the case of each feature we will support
      case x.feature
        when "misc_feature" then
          if x.assoc["label"] == "b-galactosidase"
            self.add_bgal( ori, 25, ori + 25, 75 ).draw(image)
            ori += 35
          elsif x.assoc["label"] == "En2 intron"
            self.add_En2( ori, 25, ori + 25, 75 ).draw(image)
            ori += 35
          elsif x.assoc["label"] == "neo"
            self.add_neo( ori, 25, ori + 25, 75 ).draw(image)
            ori += 35
          else
            # do nothing ...
          end
        when "polyA_site" then
          self.add_polyA_site( ori, 25, ori + 25, 75 ).draw(image)
          ori += 35
        when "exon" then
          self.add_exon( ori, 25, ori + 25, 75 ).draw(image)
          ori += 35
        when "SSR_site" then
          if x.assoc["label"].downcase == "loxp"
            self.add_loxp( ori, 25 ).draw(image) 
            ori += 35
          elsif x.assoc["label"].downcase == "frt"
            self.add_frt( ori, 25 ).draw(image)
            ori += 35
          end
        else
          # perhaps this should be controlled by an option to new?
          if @show_all
            self.add_stub_feature( ori, 25, ori + 25, 75 ).draw(image)
            ori += 35
          else
            # do nothing ...
          end
      end
    }

    return image
  end

  #
  # calculate the width of the section
  # currently done with the count of all features but it needs to be smarter
  def calc_width(features)
    gaps = 0
    if features > 1
      gaps = ( features - 1 ) * 10
    end
    # < Left pad - Features - Spaces - Right pad >
    20 + ( features * 25 ) + gaps + 20
  end

  #
  # TODO:
  # Refactor these out into a method/class that takes arguments:
  #
  #   Feature.new( name, origin ).draw( image )
  #
  # where origin is an object representing the locus from which we can extrapolate
  # all the points we need to draw any given shape.
  #

  def add_En2(x1, y1, x2, y2)
    f = Draw.new
    f.fill("white")
    f.stroke("black")
    f.rectangle(x1, y1, x2, y2)
    f
  end

  def add_neo(x1, y1, x2, y2)
    f = Draw.new
    f.fill("aqua")
    f.stroke("black")
    f.rectangle(x1, y1, x2, y2)
    f
  end

  def add_polyA_site(x1, y1, x2, y2)
    f = Draw.new
    f.fill("violet")
    f.stroke("black")
    f.rectangle(x1, y1, x2, y2)
    f
  end

  def add_backbone(x1, y1, x2, y2)
    seq = Draw.new
    seq.stroke('black')
    seq.stroke_width(5)
    seq.line(x1, y1, x2, y2)
    seq
  end

  def add_exon(x1, y1, x2, y2)
    rect = Draw.new
    rect.fill('yellow')
    rect.stroke('black')
    rect.rectangle(x1, y1, x2, y2)
    rect
  end
  
  def add_bgal(x1, y1, x2, y2)
    bgal = Draw.new
    bgal.fill('blue')
    bgal.stroke('black')
    bgal.rectangle(x1, y1, x2, y2)
    bgal
  end

  def add_loxp(x1, y1)
    loxp = Draw.new
    loxp.fill("red")
    loxp.stroke("black")
    x2 = x1 + 25
    y2 = y1 + 25
    x3 = x2 - 25 # same as x1
    y3 = y2 + 25
    loxp.polygon(x1, y1, x2, y2, x3, y3)
    loxp
  end

  def add_frt(x1, y1)
    loxp = Draw.new
    loxp.fill("green")
    loxp.stroke("black")
    x2 = x1 + 25
    y2 = y1 + 25
    x3 = x2 - 25 # same as x1
    y3 = y2 + 25
    loxp.polygon(x1, y1, x2, y2, x3, y3)
    loxp
  end

  def add_stub_feature(x1, y1, x2, y2)
    f = Draw.new
    f.fill("green")
    f.stroke("black")
    f.rectangle(x1, y1, x2, y2)
    f
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

    @canvas.append(false).write(file)
  end

end

#
# TODO:
# Should change these into proper tests and test conditional,
# non-conditional and deletion clones.
#

ai = AlleleImaging.new('/Users/io1/Documents/allele-imaging/2009_11_27_conditional_linear.gbk')

# puts "number of rcmb_primers: #{ ai.rcmb_primers.count }"
# puts ai.rcmb_primers.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts "number of features: #{ ai.features.count }"
# puts 'five_flank_features:'
# puts ai.five_flank_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'five_homology_features:'
# puts ai.five_homology_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'cassette_features:'
# puts ai.cassette_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'target_region_features:'
# puts ai.target_region_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'loxP_region_features:'
# puts ai.loxP_region_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'three_homology_features:'
# puts ai.three_homology_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'three_flank_features:'
# puts ai.three_flank_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# 
# puts 'primer_row_features:'
# puts ai.primer_row_features.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'five_flank_annotations:'
# puts ai.five_flank_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'five_homology_annotations:'
# puts ai.five_homology_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'cassette_annotations:'
# puts ai.cassette_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'target_region_annotations:'
# puts ai.target_region_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'loxP_region_annotations:'
# puts ai.loxP_region_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'three_homology_annotations:'
# puts ai.three_homology_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }
# puts 'three_flank_annotations:'
# puts ai.three_flank_annotations.map { |x| "[ label : #{ x.assoc['label'] }, feature : #{ x.feature } ]" }

puts 'testing drawing:'
ai.draw_image('ai.png')
