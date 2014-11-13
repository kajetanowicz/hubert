begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end

  task default: :spec
rescue LoadError
end

task :benchmark do
  Dir['benchmark/**/*.rb'].each do |benchmark|
    sh 'ruby', benchmark
  end
end
