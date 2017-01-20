require_relative './bench_init'

context "Projecting a Specific Version of an Entity" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get 'testProjectSpecificVersion'

  message_0 = EventStore::EntityProjection::Controls::Message.example 'value-of-version-0'
  message_1 = EventStore::EntityProjection::Controls::Message.example 'value-of-version-1'

  EventStore::EntityProjection::Controls::Writer.write message_0, stream_name
  EventStore::EntityProjection::Controls::Writer.write message_1, stream_name

  entity = EventStore::EntityProjection::Controls::Entity.example

  projection = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.build entity

  ending_position = 0

  event_number = nil

  read = EventSource::EventStore::HTTP::Read.build stream_name, position: 0, batch_size: 1
  read.() do |event_data|
    projection.(event_data)
    event_number = event_data.position
    break if event_data.position == ending_position
  end

  test "Last version considered matches specified version" do
    assert event_number == ending_position
  end

  test "Messages written after specified version are not applied" do
    assert entity.some_attribute == 'value-of-version-0'
  end
end
