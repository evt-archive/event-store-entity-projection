require_relative 'spec_init'

describe "Project Messages into an Entity from a Stream" do
  stream_name = EventStore::EntityProjection::Controls::Writer.write_batch 'testProjection'

  entity = EventStore::EntityProjection::Controls::Entity.example

  event_number = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.(entity, stream_name, starting_position: 0, slice_size: 1)

  describe "Entity Attributes" do
    specify "some_attribute" do
      assert(entity.some_attribute == EventStore::EntityProjection::Controls::Message.attribute)
    end

    specify "some_time" do
      assert(entity.some_time == EventStore::EntityProjection::Controls::Message.time)
    end
  end

  specify "Version" do
    assert(event_number == 1)
  end
end
