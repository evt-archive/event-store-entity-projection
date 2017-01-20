module EventStore
  module EntityProjection
    def self.included(cls)
      cls.class_exec do
        include Log::Dependency
        include ::EntityProjection

        extend Build
        extend Actuate
        include Call

        attr_accessor :ending_position

        dependency :read, EventSource::Read
      end
    end

    def apply(message)
      handle_message message
    end

    module Build
      def build(entity, stream_name, starting_position: nil, ending_position: nil, slice_size: nil, session: nil)
        new(entity).tap do |instance|
          instance.ending_position = ending_position unless ending_position.nil?

          EventSource::EventStore::HTTP::Read.configure(
            instance,
            stream_name,
            position: starting_position,
            batch_size: slice_size,
            session: session
          )
        end
      end
    end

    module Actuate
      def call(entity, stream_name, **arguments)
        instance = build entity, stream_name, **arguments
        instance.()
      end
      alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]
    end

    module Call
      def self.included(cls)
        cls.class_exec do
          alias_method :project, :call
          alias_method :call, :call_replacement
          alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]
        end
      end

      def call_replacement
        logger.trace { "Running projection" }

        last_event_number = nil

        read.() do |event_data|
          last_event_number = event_data.position

          project event_data

          break if last_event_number == ending_position
        end

        logger.debug { "Ran projection (Last Event Number: #{last_event_number.inspect})" }

        last_event_number
      end
    end
  end
end
