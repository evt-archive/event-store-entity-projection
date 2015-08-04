require_relative 'spec_init'

describe "Project Messages into an Entity" do
  entity = Projection::Controls::Entity.example
  messages = Projection::Controls::Message.examples

  Projection::Project.! entity, messages

  describe "Attribute Values are Set" do
    specify "some_attribute" do
      assert(entity.some_attribute == Projection::Controls::Message.attribute)
    end

    specify "some_time" do
      assert(entity.some_time == Projection::Controls::Message.time)
    end
  end
end
