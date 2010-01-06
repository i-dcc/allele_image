#!/usr/bin/env ruby -wKU
require "row"

class Grid
  attr_reader :features, :is_circular, :rows
  attr_reader :rcmb_primers # not sure if this needs to be explicit
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

    @rows = @is_circular == 0 ? 3 : 5
  end
  
end
