# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'footballer/photo/version'

Gem::Specification.new do |spec|
  spec.name          = "footballer-photo"
  spec.version       = Footballer::Photo::VERSION
  spec.authors       = ["Trinh Duc Duy"]
  spec.email         = ["duytd.hanu@gmail.com"]

  spec.summary       = %q{Fetch Footballer Photo From SoccerWiki.}
  spec.description   = %q{Fetch Footballer Photo From SoccerWiki.}
  spec.homepage      = "https://github.com/duytd/footballer-photo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 3.0"
  spec.add_dependency "nokogiri"
end
