# frozen_string_literal: true

require_relative "lib/tailwind_merge/version"

Gem::Specification.new do |spec|
  spec.name = "tailwind_merge"
  spec.version = TailwindMerge::VERSION
  spec.authors = ["Garen J. Torikian"]
  spec.email = ["gjtorikian@gmail.com"]

  spec.summary = "Utility function to efficiently merge Tailwind CSS classes without style conflicts."
  spec.homepage = "https://www.github.com/gjtorikian/tailwind_merge"
  spec.license = "MIT"

  spec.required_ruby_version = [">= 3.1", "< 4.0"]

  spec.metadata = {
    "funding_uri" => "https://github.com/sponsors/gjtorikian/",
    "rubygems_mfa_required" => "true",
  }

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    %x(git ls-files -z).split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/tailwind_merge/Cargo.toml"]

  spec.add_dependency("lru_redux", "~> 1.1")

  spec.add_development_dependency("minitest", "~> 5.6")
  spec.add_development_dependency("minitest-focus", "~> 1.1")
end
