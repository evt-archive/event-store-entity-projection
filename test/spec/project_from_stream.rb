require_relative 'spec_init'

describe "Project Messages into an Entity from a Stream" do
  stream_name = EventStore::Projection::Controls::Writer.write 1, 'testProjection'

  entity = EventStore::Projection::Controls::Entity.example

  EventStore::Projection::Controls::Projection::SomeProjection.! entity, stream_name, starting_position: 0, slice_size: 1

  describe "Entity Attributes" do
    specify "some_attribute" do
      assert(entity.some_attribute == EventStore::Projection::Controls::Message.attribute)
    end

    specify "some_time" do
      assert(entity.some_time == EventStore::Projection::Controls::Message.time)
    end
  end
end
