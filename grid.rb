#!/usr/bin/env ruby -wKU

class Grid
  attr_reader :features, :rcmb_primers, :rows, :is_circular
  attr_reader :annotation_features, :main_features

  # Not 100% sure if a Grid should have/allow access to @features and @rcmb_primers
  def initialize(features, is_circular)
    @is_circular = is_circular

    # Manage the features
    @features = features.sort do |a,b|
      a.position <=> b.position
    end

    @rcmb_primers = @features.select do |x|
      x.name == "rcmb_primer"
    end

    @annotation_features = @features.select do |x|
         x.name.downcase == 'rcmb_primer'  \
      or x.name.downcase == 'lrpcr_primer' \
      or x.name.downcase == 'genomic'
    end

    @main_features = @features.select do |x|
          x.name.downcase != 'rcmb_primer'  \
      and x.name.downcase != 'lrpcr_primer' \
      and x.name.downcase != 'genomic'      \
      and x.name.downcase != 'primer_bind'
    end

    @rows = 3
    @rows = 5 if @is_circular == 1
  end
  
end
