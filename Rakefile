require "bundler/gem_tasks"

require 'bundler/setup'

require 'rake/testtask'

desc 'Run Tests'
Rake::TestTask.new do |t|
  t.test_files = Rake::FileList['test/**/*_test.rb']
end

task default: :test
