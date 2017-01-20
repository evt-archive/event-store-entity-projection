require_relative 'bench_init'

context "Projecting Unhandled Messages into an Entity from a Stream" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get 'testProjectUnhandledException'

  unhandled_message = EventStore::EntityProjection::Controls::Message.unhandled
  handled_message = EventStore::EntityProjection::Controls::Message.some_message

  EventStore::EntityProjection::Controls::Writer.write handled_message, stream_name
  EventStore::EntityProjection::Controls::Writer.write unhandled_message, stream_name

  entity = EventStore::EntityProjection::Controls::Entity.example

  projection = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.build entity

  event_number = nil

  read = EventSource::EventStore::HTTP::Read.build stream_name, position: 0, batch_size: 1
  read.() do |event_data|
    projection.(event_data)
    event_number = event_data.position
  end

  test "Counts each event in the version number" do
    assert(event_number == 1)
  end
end
