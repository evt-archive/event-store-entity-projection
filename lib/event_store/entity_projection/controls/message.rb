module EventStore
  module EntityProjection
    module Controls
      module Message
        class SomeMessage
          include EventStore::Messaging::Message

          attribute :some_attribute
        end

        class OtherMessage
          include EventStore::Messaging::Message

          attribute :some_time
        end

        class UnhandledMessage
          include EventStore::Messaging::Message
        end

        def self.attribute
          'some value'
        end

        def self.time(time=nil)
          time || Time.example
        end

        def self.example(attribute_value=nil)
          attribute_value ||= attribute

          msg = SomeMessage.new
          msg.some_attribute = attribute_value
          msg
        end

        def self.some_message
          example
        end

        def self.other_message
          msg = OtherMessage.new
          msg.some_time = time
          msg
        end

        def self.examples
          [some_message, other_message]
        end

        def self.unhandled
          UnhandledMessage.new
        end
      end
    end
  end
end
