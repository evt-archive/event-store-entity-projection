module Projection
  def self.included(cls)
    cls.extend Logger
    # cls.extend BuildDispatcher
    # cls.extend Build
    # cls.extend Actuate

    cls.extend ApplyMacro
    cls.extend Info
    cls.extend EventStore::Messaging::Dispatcher::MessageRegistry
    # cls.extend EventStore::Messaging::Dispatcher::HandlerRegistry

    cls.send :dependency, :reader, EventStore::Messaging::Reader
    cls.send :dependency, :logger, Telemetry::Logger
  end

  module Logger
    def logger
      Logger::Telemetry.get self
    end
  end

  module ApplyMacro
    def apply_macro(message_class, &blk)
      define_handler_method(message_class, &blk)
      message_registry.register(message_class)
    end
    alias :apply :apply_macro

    def define_handler_method(message_class, &blk)
      logger = Telemetry::Logger.get self

      logger.trace "Defining projection method (Message: #{message_class})"

      projection_method_name = handler_name(message_class)
      send(:define_method, projection_method_name, &blk).tap do
        logger.debug "Defined projection method (Method Name: #{projection_method_name}, Message: #{message_class})"
      end
    end
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
    def self.build(entity, stream_name, starting_position: nil, slice_size: nil)
      new.tap do |instance|
        dispatcher = build_dispatcher(instance)
        EventStore::Messaging::Reader.configure instance, dispatcher, starting_position: starting_position, slice_size: slice_size
        Telemetry::Logger.configure instance
      end
    end
  end

  module BuildDispatcher
    def self.build_dispatcher(instance)
      dispatcher.class.handler instance.class
      dispatcher
    end
  end

  module Actuate
    def !(entity, stream_name, starting_position: nil, slice_size: nil)
      instance = build(entity, stream_name, starting_position: starting_position, slice_size: slice_size)
      instance.!
    end
  end

  def !
  end
end