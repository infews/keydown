require 'bundler'
Bundler::GemHelper.install_tasks

desc "Run all specs"
task :spec do
  system("rspec spec")
end

task :default => :spec
