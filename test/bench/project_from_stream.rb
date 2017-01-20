require_relative 'bench_init'

context "Project Messages into an Entity from a Stream" do
  stream_name = EventStore::EntityProjection::Controls::Writer.write_batch 'testProjection'

  entity = EventStore::EntityProjection::Controls::Entity.example

  projection = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.build entity

  event_number = nil

  read = EventSource::EventStore::HTTP::Read.build stream_name, position: 0, batch_size: 1
  read.() do |event_data|
    projection.(event_data)
    event_number = event_data.position
  end

  context "Entity Attributes" do
    test "some_attribute" do
      assert(entity.some_attribute == EventStore::EntityProjection::Controls::Message.attribute)
    end

    test "some_time" do
      assert(entity.some_time == EventStore::EntityProjection::Controls::Message.time)
    end
  end

  test "Version" do
    assert(event_number == 1)
  end
end
