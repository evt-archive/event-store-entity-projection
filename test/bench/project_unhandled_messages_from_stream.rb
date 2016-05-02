require_relative 'bench_init'

context "Projecting Unhandled Messages into an Entity from a Stream" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get 'testProjectUnhandledException'

  unhandled_message = EventStore::EntityProjection::Controls::Message.unhandled
  handled_message = EventStore::EntityProjection::Controls::Message.some_message

  EventStore::EntityProjection::Controls::Writer.write handled_message, stream_name
  EventStore::EntityProjection::Controls::Writer.write unhandled_message, stream_name

  entity = EventStore::EntityProjection::Controls::Entity.example

  last_event_number = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.(entity, stream_name)

  test "Counts each event in the version number" do
    assert(last_event_number == 1)
  end
end
