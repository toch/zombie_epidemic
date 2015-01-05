require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'spec'
  t.test_files = FileList['spec/**/*_spec.rb']
end

desc 'Run tests'
task default: :test

desc 'Run a console with the loaded library'
task :console do
  exec 'irb -r zombie_epidemic -I ./lib'
end

desc 'Make a movie from sequence of maps'
task :movie, [:directory] do |t, args|
  puts 'missing directory' if args.directory.nil?
  exec "convert -delay 10 -loop 0 #{args.directory}/*.png #{args.directory}.gif"
end