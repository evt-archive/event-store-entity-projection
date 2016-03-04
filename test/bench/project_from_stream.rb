require_relative 'bench_init'

context "Project Messages into an Entity from a Stream" do
  stream_name = EventStore::EntityProjection::Controls::Writer.write_batch 'testProjection'

  entity = EventStore::EntityProjection::Controls::Entity.example

  event_number = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.(entity, stream_name, starting_position: 0, slice_size: 1)

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
