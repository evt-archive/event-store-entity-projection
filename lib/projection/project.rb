module Projection
  class Project
    attr_accessor :entity

    dependency :reader, EventStore::Messaging::Reader
    dependency :logger, Telemetry::Logger

    def initialize(entity)
      @entity = entity
    end

    def self.build(entity, stream_name, starting_position: nil, slice_size: nil)
      new(entity).tap do |instance|
        dispatcher = build_dispatcher
        EventStore::Messaging::Reader.configure instance, dispatcher, starting_position: starting_position, slice_size: slice_size
        Telemetry::Logger.configure instance
      end
    end

    def self.!(entity, stream_name, starting_position: nil, slice_size: nil)
      instance = build(entity, stream_name, starting_position: starting_position, slice_size: slice_size)
      instance.()
    end

    def !
    end

    def self.logger
      Logger::Telemetry.get
    end
  end
end
