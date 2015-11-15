require_relative 'spec_init'

describe "Apply Messages" do
  entity = EventStore::EntityProjection::Controls::Entity.example

  projection = EventStore::EntityProjection::Controls::EntityProjection.example

  specify "SomeMessage" do
    some_message = EventStore::EntityProjection::Controls::Message::SomeMessage.build    # projection.apply some_message, entity
    projection.apply some_message
    assert(entity.some_attribute == some_message.some_attribute)
  end

  specify "OtherMessage" do
    other_message = EventStore::EntityProjection::Controls::Message::OtherMessage.build
    projection.apply other_message
    assert(entity.some_time == other_message.some_time)
  end
end
