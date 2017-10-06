# coding: utf-8
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proc_parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'proc_parser'
  spec.version       = ProcParser::VERSION
  spec.authors       = ['Étienne Michon']
  spec.email         = ['etienne@scalingo.com']

  spec.summary       = 'ProcParser provides a Ruby wrapper for /proc data'
  spec.description   = 'ProcParser provides a Ruby wrapper for /proc data such as mem_info, stat
                          and loadavg'
  spec.homepage      = 'https://github.com/EtienneM/proc_parser'
  spec.license       = 'MIT'
  spec.required_ruby_version = '~> 2.4'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.1'
  spec.add_development_dependency 'rspec', '~> 3.6'
end
