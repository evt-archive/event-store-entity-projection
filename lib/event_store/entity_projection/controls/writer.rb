module EventStore
  module EntityProjection
    module Controls
      module Writer
        def self.write_batch(stream_name=nil)
          stream_name = Controls::StreamName.get stream_name
          path = "/streams/#{stream_name}"

          writer = EventStore::Messaging::Writer.build

          messages = Controls::Message.examples

          writer.write messages, stream_name

          stream_name
        end
      end
    end
  end
end
