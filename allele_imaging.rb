#!/usr/bin/env ruby
require 'bio'

class AlleleImaging
  attr_reader :features, :input_file, :rcmb_primers, :bio_seq

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
  end

  def main_features
    @features.select { |x| x.feature.downcase != 'rcmb_primer' && x.feature.downcase != 'lrpcr_primer' && x.feature.downcase != 'genomic' }
  end

  def primer(label)
    primer = @rcmb_primers.select { |x| x.assoc['label']  == label }
    if primer.count > 1
      puts 'more than one primer'
    end
    primer[0]
  end

  # def primer_location(label)
  #   primer(label).locations.first.from
  # end

  # This block of methods allocates the features on row 2 into the
  # appropriate columns.
  def five_flank_features
    main_features.select { |x| x.locations.first.from < primer('G5').locations.first.from }
  end

  def five_homology_features
    main_features.select { |x| x.locations.first.from > primer('G5').locations.first.from && x.locations.first.from < primer('U5').locations.first.from }
  end

  def cassette_features
    main_features.select { |x| x.locations.first.from > primer('U5').locations.first.from && x.locations.first.from < primer('U3').locations.first.from }
  end

  def target_region_features
    main_features.select { |x| x.locations.first.from > primer('U3').locations.first.from && x.locations.first.from < primer('D5').locations.first.from }
  end

  def loxP_region_features
    main_features.select { |x| x.locations.first.from > primer('D5').locations.first.from && x.locations.first.from < primer('D3').locations.first.from }
  end

  def three_homology_features
    main_features.select { |x| x.locations.first.from > primer('D3').locations.first.from && x.locations.first.from < primer('G3').locations.first.from }
  end
  
  def three_flank_features
    main_features.select { |x| x.locations.first.from > primer('G3').locations.first.from }
  end
end

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
