require_relative 'bench_init'

context "Projecting Unhandled Messages into an Entity from a Stream" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get 'testProjectUnhandledException'

  unhandled_message = EventStore::EntityProjection::Controls::Message.unhandled

  EventStore::EntityProjection::Controls::Writer.write unhandled_message, stream_name

  entity = EventStore::EntityProjection::Controls::Entity.example

  test "Is not an error (and does not apply the unhandled message)" do
    EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.(entity, stream_name)
  end
end
