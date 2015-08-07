require_relative 'spec_init'

describe "Project Messages into an Entity" do
  entity = Projection::Controls::Entity.example
  stream_name = Projection::Controls::Writer.write 1, 'testProjection'

  projection = Projection::Controls::Projection.build entity, stream_name, starting_position: 0, slice_size: 1
  projection.!

  describe "Entity Attributes" do
    specify "some_attribute" do
      assert(entity.some_attribute == Projection::Controls::Entity.attribute)
    end

    specify "some_time"
  end
end
