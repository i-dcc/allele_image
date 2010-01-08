#!/usr/bin/env ruby -wKU
require "row"

class Grid
  attr_reader :features, :is_circular, :rows
  attr_reader :rcmb_primers
  attr_reader :annotation_features, :main_features

  # Not 100% sure if a Grid should have/allow access to @features and @rcmb_primers
  def initialize(features, is_circular)
    @is_circular = is_circular

    # Manage the features
    @features = features.sort do |a,b|
      a.position <=> b.position
    end

    @rcmb_primers = @features.select do |x|
      x.type == "rcmb_primer"
    end

    @annotation_features = @features.select do |x|
      x.type.downcase == "lrpcr_primer" or x.type.downcase == "genomic"
    end

    @main_features = @features.select do |x|
          x.type.downcase != "rcmb_primer"  \
      and x.type.downcase != "lrpcr_primer" \
      and x.type.downcase != "genomic"      \
      and x.type.downcase != "primer_bind"
    end

    # Generate the correct number of rows
    @rows    = Array.new()
    @rows[0] = Row.new(0, @annotation_features)
    @rows[1] = Row.new(1, @main_features)
    @rows[2] = Row.new(2, @main_features)
    
    if @is_circular == 1
      @rows[3] = Row.new(3, [])
      @rows[4] = Row.new(4, [])
    end
  end
  
end
