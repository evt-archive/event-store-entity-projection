module EventStore
  module EntityProjection
    def self.included(cls)
      cls.class_exec do
        include Log::Dependency

        extend Logger
        extend Build
        extend Actuate
        extend ApplyMacro
        extend EntityNameMacro
        extend Info
        extend EventStore::Messaging::Dispatcher::MessageRegistry
        extend EventStore::Messaging::Dispatcher::BuildMessage

        initializer :entity

        attr_accessor :ending_position

        dependency :read, EventSource::Read
      end
    end

    module Logger
      def logger
        Log.get self
      end
    end

    module ApplyMacro
      def apply_macro(message_class, &blk)
        define_handler_method(message_class, &blk)
        message_registry.register(message_class)
      end
      alias :apply :apply_macro

      def define_handler_method(message_class, &blk)
        logger = Log.get self

        logger.trace { "Defining projection method (Message: #{message_class})" }

        projection_method_name = handler_name(message_class)
        send(:define_method, projection_method_name, &blk).tap do
          logger.debug { "Defined projection method (Method Name: #{projection_method_name}, Message: #{message_class})" }
        end
      end
    end

    module EntityNameMacro
      def entity_name_macro(entity_name)
        send(:define_method, entity_name) do
          entity
        end
      end
      alias :entity_name :entity_name_macro
    end

    module Info
      extend self

      def handles?(message)
        method_defined? handler_name(message)
      end

      def handler_name(message)
        name = EventStore::Messaging::Message::Info.message_name(message)
        "apply_#{name}"
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

    def call
      logger.trace { "Running projection" }

      last_event_number = nil
      
      read.() do |event_data|
        last_event_number = event_data.position

        message = build_message event_data

        dispatch message, event_data

        break if last_event_number == ending_position
      end

      logger.debug { "Ran projection (Last Event Number: #{last_event_number.inspect})" }

      last_event_number
    end
    alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

    def build_message(entry_data)
      self.class.build_message(entry_data)
    end

    def dispatch(message, _)
      if self.class.handles?(message)
        apply message
      end
    end

    def apply(message)
      logger.trace { "Applying #{message.class.name} to #{entity.class.name}" }
      handler_method_name = Info.handler_name(message)

      send(handler_method_name, message).tap do
        logger.debug { "Applied #{message.class.name} to #{entity.class.name}" }
        logger.debug { entity.pretty_inspect }
      end

      nil
    end
  end
end
