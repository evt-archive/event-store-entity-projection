require_relative './bench_init'

context "Projecting a Specific Version of an Entity" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get 'testProjectSpecificVersion'

  message_0 = EventStore::EntityProjection::Controls::Message.example 'value-of-version-0'
  message_1 = EventStore::EntityProjection::Controls::Message.example 'value-of-version-1'

  EventStore::EntityProjection::Controls::Writer.write message_0, stream_name
  EventStore::EntityProjection::Controls::Writer.write message_1, stream_name

  entity = EventStore::EntityProjection::Controls::Entity.example

  last_event_number = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.(entity, stream_name, version: 0)

  test "Last version considered matches specified version" do
    assert last_event_number == 0
  end

  test "Messages written after specified version are not applied" do
    assert entity.some_attribute == 'value-of-version-0'
  end
end
