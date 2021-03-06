# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-entity_projection'
  s.version = '0.4.0.0.pre2'
  s.summary = 'Projects an event stream into an entity'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/event-store-entity-projection'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.3'

  s.add_runtime_dependency 'evt-messaging-event_store'
  s.add_runtime_dependency 'evt-entity_projection'

  s.add_development_dependency 'test_bench'
end
