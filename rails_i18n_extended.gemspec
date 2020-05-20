require_relative 'lib/rails_i18n_extended/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_i18n_extended"
  spec.version       = RailsI18nExtended::VERSION
  spec.authors       = ["Johan VAN RYSEGHEM", "Etienne DEPAULIS"]
  spec.email         = ["johan@about-blank.fr", "Etienne.depaulis@gmail.com"]

  spec.summary       = 'Add a few helpers for I18n in RoR'
  spec.description   = %q{This gem adds helpers on ActiveRecord models to shorten the I18n.t calls. It also provides a fallback on the default locale, and a glocab default mechanism (see Readme for more infos)}
  spec.homepage      = "https://github.com/honestica/rails_i18n_extended"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/honestica/rails_i18n_extended"
  spec.metadata["changelog_uri"] = "https://github.com/honestica/rails_i18n_extended"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency "rails"
  spec.add_dependency "activerecord", ">= 6"
  spec.add_development_dependency "sqlite3"
end
