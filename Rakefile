# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/mxit_api/version.rb'
Jeweler::Tasks.new do |gem|
  gem.name = "mxit_api"
  gem.homepage = "http://github.com/unboxed/mxit_api"
  gem.license = "MIT"
  gem.summary = %Q{gem to use Mxit APIs}
  gem.description = %Q{gem to use the Mxit APIs at http://dev.mxit.com/docs/ }
  gem.email = "grant.speelman@unboxedconsulting.com"
  gem.authors = ["Grant Speelman"]
  gem.version = MXitApi::Version::STRING
  # dependencies defined in Gemfile
  gem.add_dependency 'activesupport', '>= 3.0.0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mxit_api #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
