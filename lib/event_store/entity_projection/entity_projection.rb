module EventStore
  module EntityProjection
    def self.included(cls)
      cls.class_exec do
        include Log::Dependency
        include ::EntityProjection

        extend Build
        extend Actuate
        include Call

        initializer :entity

        attr_accessor :ending_position

        dependency :read, EventSource::Read
      end
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
      def call
        logger.trace { "Running projection" }

        last_event_number = nil

        read.() do |event_data|
          last_event_number = event_data.position

          message = build_message event_data

          dispatch message, event_data unless message.nil?

          break if last_event_number == ending_position
        end

        logger.debug { "Ran projection (Last Event Number: #{last_event_number.inspect})" }

        last_event_number
      end
      alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]
    end

    def build_message(event_data)
      message_name = ::Messaging::Message::Info.canonize_name event_data.type

      message_class = self.class.message_registry.get message_name

      return nil if message_class.nil?

      ::Messaging::Message::Import.(event_data, message_class)
    end

    def dispatch(message, _)
      if self.class.handles?(message)
        apply message
      end
    end

    def apply(message)
      logger.trace { "Applying #{message.class.name} to #{entity.class.name}" }
      handler_method_name = ::EntityProjection::Info.handler_name(message)

      send(handler_method_name, message).tap do
        logger.debug { "Applied #{message.class.name} to #{entity.class.name}" }
        logger.debug { entity.pretty_inspect }
      end

      nil
    end
  end
end
