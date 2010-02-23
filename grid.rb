#!/usr/bin/env ruby -wKU
require "row"

class Grid
  attr_reader :features, :is_circular, :rows
  attr_reader :rcmb_primers
  attr_reader :annotation_features, :main_features

  def initialize(features, is_circular)
    @is_circular = is_circular

    @rcmb_primers = features.select { |x| x.type.downcase == "rcmb_primer" }

    # Manage the features
    @features = features.sort { |a,b| a.start <=> b.start }

    @annotation_features = @features.select do |x|
         x.type.downcase == "rcmb_primer"  \
      or x.type.downcase == "lrpcr_primer" \
      or x.type.downcase == "genomic"
    end

    @main_features = @features.select do |x|
          x.type.downcase != "rcmb_primer"  \
      and x.type.downcase != "lrpcr_primer" \
      and x.type.downcase != "genomic"      \
      and x.type.downcase != "primer_bind"
    end

    # Generate the correct number of rows
    @rows    = Array.new()
    @rows[0] = Row.new(0, @annotation_features, @rcmb_primers)
    @rows[1] = Row.new(1, @main_features, @rcmb_primers)
    @rows[2] = Row.new(2, @main_features, @rcmb_primers)
    
    if @is_circular == 1
      @rows[3] = Row.new(3, [], @rcmb_primers)
      @rows[4] = Row.new(4, [], @rcmb_primers)
    end
  end

  def render(format, params={})
    format.new(self).render(params)
  end
end
