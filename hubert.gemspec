require File.expand_path('../lib/hubert/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'hubert'
  gem.version       = Hubert::VERSION
  gem.summary       = 'Hubert: simple http URL builder tool'
  gem.description   = 'Hubert makes it easy to generate URLs using template strings known from Ruby On Rails framework.'

  gem.authors       = ['Andrzej Kajetanowicz']
  gem.email         = ['andrzej.kajetanowicz@gmail.com']
  gem.homepage      = 'https://github.com/kajetanowicz/hubert'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.7'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
end
