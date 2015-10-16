# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-entity_projection'
  s.summary = 'Projects an event stream into an entity'
  s.version = '0.1.0'
  s.authors = ['']
  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'inclusion', '1.0.0'

  s.add_runtime_dependency 'set_attributes'
  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'telemetry-logger'
  s.add_runtime_dependency 'dependency'
  s.add_runtime_dependency 'event_store-messaging'
end
