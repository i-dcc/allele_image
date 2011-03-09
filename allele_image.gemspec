# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{allele_image}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nelo Onyiah"]
  s.date = %q{2011-03-09}
  s.description = %q{}
  s.email = ["io1@sanger.ac.uk"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/allele_image.rb", "lib/allele_image/construct.rb", "lib/allele_image/feature.rb", "lib/allele_image/image.rb", "lib/allele_image/parser.rb", "lib/allele_image/renderable_features.rb", "lib/allele_image/renderer.rb", "script/console", "script/destroy", "script/generate", "tasks/metrics.rake", "test/test_allele_image.rb", "test/test_construct.rb", "test/test_coverage_failures.rb", "test/test_empty_regions.rb", "test/test_feature.rb", "test/test_helper.rb", "test/test_image.rb", "test/test_parser.rb", "test/test_renderer.rb", "test/test_functional_units.rb", "test/test_missing_exons.rb", "test/test_regeneron_products.rb"]
  s.homepage = %q{http://github.com/j1n3l0/allele-imaging}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{allele_image}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Generate allele images in a specified format from a genomic data}
  s.test_files = ["test/test_allele_image.rb", "test/test_construct.rb", "test/test_coverage_failures.rb", "test/test_empty_regions.rb", "test/test_feature.rb", "test/test_functional_units.rb", "test/test_helper.rb", "test/test_image.rb", "test/test_missing_exons.rb", "test/test_parser.rb", "test/test_regeneron_products.rb", "test/test_renderer.rb"]

  s.add_dependency "bio"
  s.add_dependency "rmagick"

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.8.0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.8.0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.8.0"])
  end
end
