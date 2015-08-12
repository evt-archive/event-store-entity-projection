module EventStore
  module EntityProjection
    module Controls
      module Writer
        def self.write_batch(stream_name=nil)
          stream_name = Controls::StreamName.get stream_name

          writer = EventStore::Messaging::Writer.build

          messages = Controls::Message.examples

          writer.write messages, stream_name

          stream_name
        end

        def self.write_first(stream_name)
          message = Controls::Message.some_message

          write message, stream_name

          stream_name
        end

        def self.write_second(stream_name)
          message = Controls::Message.other_message

          write message, stream_name

          stream_name
        end

        def self.write(message, stream_name)

          writer = EventStore::Messaging::Writer.build

          writer.write message, stream_name
        end
      end
    end
  end
end
