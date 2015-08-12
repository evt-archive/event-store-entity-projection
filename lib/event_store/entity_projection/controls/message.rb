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

        def self.attribute
          'some value'
        end

        def self.time(time=nil)
          time || ::Controls::Time.reference
        end

        def self.example
          msg = SomeMessage.new
          msg.some_attribute = attribute
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
      end
    end
  end
end
