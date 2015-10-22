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

namespace :movie do
  desc 'Create a MPG movie from sequence of maps'
  task :create, [:directory, :framerate] do |t, args|
    abort 'missing directory' if args.directory.nil?
    framerate = args.framerate
    framerate ||= 5
    exec "ffmpeg -framerate #{framerate} -pattern_type glob -i '#{args.directory}/step_*.png' -s:v 500x500 -c:v libx264 -pix_fmt yuv420p #{args.directory}.mpg"
  end

  desc 'Play the associated movie'
  task :play, [:directory] do |t, args|
    abort 'missing movie file' if args.directory.nil?
    exec "ffplay #{args.directory}.mpg"
  end
end

desc 'Make an animated GIF from sequence of maps'
task :gif, [:directory] do |t, args|
  abort 'missing directory' if args.directory.nil?
  exec "convert -delay 10 -loop 0 #{args.directory}/*.png #{args.directory}.gif"
end

desc 'replay into terminal'
task :replay, [:directory] do |t, args|
  puts 'missing directory' if args.directory.nil?
  Dir.glob("#{args.directory}/step_*.png").sort.each do |file|
    puts `img2txt -H 31 -d none #{file}`
    sleep 1
  end
end
