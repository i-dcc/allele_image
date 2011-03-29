# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "allele_image/version"

Gem::Specification.new do |s|
  s.name        = "allele_image"
  s.version     = AlleleImage::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nelo Onyiah"]
  s.email       = ["io1@sanger.ac.uk"]
  s.homepage    = "http://github.com/i-dcc/allele-imaging"
  s.summary     = %q{Generate cartoon depictions of your gene knockouts}
  s.description = %q{AlleleImage dynamically generates a cartoon of a gene described in a valid GenBank file}

  s.rubyforge_project = "allele_image"

  s.add_dependency "bio"
  s.add_dependency "rmagick"

  s.add_development_dependency "awesome_print"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "yard"
  s.add_development_dependency "hoe"
  s.add_development_dependency "newgem"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
