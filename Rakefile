# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubygems/package_task"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

GEMSPEC = Bundler.load_gemspec("tailwind_merge.gemspec")
gem_path = Gem::PackageTask.new(GEMSPEC).define
desc "Package the ruby gem"
task "package" => [gem_path]

require "rb_sys/extensiontask"

desc "Compile the Rust extension"
task build: :compile

RbSys::ExtensionTask.new("tailwind_merge") do |ext|
  ext.lib_dir = "lib/tailwind_merge"
end

task default: [:compile, :test, :rubocop]
