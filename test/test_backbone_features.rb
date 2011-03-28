require 'test_helper'

class TestBackboneFeatures < Test::Unit::TestCase
  context "An AlleleImage with a backbone" do
    setup do
      @data_dir  = "#{File.dirname(__FILE__)}/../misc/known-issues/backbones"
      @backbones = [
        {     # ---AsiSI---//---|SpecR|-----------|pA|DTA|PGK|---
                  :file => "#{@data_dir}/28377.gbk",
                 :label => "L3L4_pZero_DTA_spec",
              :features => [ "AsiSI", "SpecR", "pA", "DTA", "PGK" ]
        },
        {     # ---AsiSI---//---|pA|DTA|PGK|------|SpecR|--------
                  :file => "#{@data_dir}/139.gbk",
                 :label => "L4L3_pD223_DTA_spec",
              :features => [ "AsiSI", "pA", "DTA", "PGK", "SpecR", "ori" ]
        },
        {     # ---AsiSI---//---|AmpR|BsdR|-------|pA|DTA|PGK|---
                  :file => "#{@data_dir}/138.gbk",
                 :label => "R3R4_pBR_DTA+_Bsd_amp",
              :features => [ "AsiSI", "AmpR", "BsdR", "pA", "DTA", "PGK" ]
        },
        {     # ---AsiSI---//---|SpecR|-----------|PGK|DTA|pA|---
                  :file => "#{@data_dir}/142.gbk",
                 :label => "L3L4_pD223_DTA_T_spec",
              :features => [ "AsiSI", "ori", "SpecR", "PGK", "DTA", "pA" ]
        },
        {     # ---AsiSI---//---|SpecR|-----------|PGK|DTA|pA|---
                  :file => "#{@data_dir}/144.gbk",
                 :label => "L3L4_pD223_DTA_spec",
              :features => [ "AsiSI", "ori", "SpecR", "PGK", "DTA", "pA" ]
        },
        {     # ---AsiSI---//---|KanR|------------|pA|DTA|PGK|---
                  :file => "#{@data_dir}/148.gbk",
                 :label => "L3L4_pZero_DTA_kan",
              :features => [ "AsiSI", "KanR", "pA", "DTA", "PGK" ]
        },
        {     # ---AsiSI---//---|AmpR|---------------------------
                  :file => "#{@data_dir}/385.gbk",
                 :label => "R3R4_pBR_amp",
              :features => [ "AsiSI", "AmpR" ]
        },
        {     # ---AsiSI---//---|KanR|---------------------------
                  :file => "#{@data_dir}/612.gbk",
                 :label => "L3L4_pZero_kan",
              :features => [ "AsiSI", "KanR" ]
        }
      ]
    end

    should "have the expected backbone features" do
      @backbones.each do |params|
        allele_image  = AlleleImage::Image.new(params[:file])
        feature_names = allele_image.construct.backbone_features.collect do |feature|
          feature.feature_name
        end
        allele_image.render.write( params[:file].gsub(/gbk$/, "gif") )
        assert_equal params[:features], feature_names, "Backbone features don't match"
      end
    end
  end
end
