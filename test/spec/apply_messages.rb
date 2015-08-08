require_relative 'spec_init'

describe "Apply Messages" do
  entity = EventStore::Projection::Controls::Entity.example

  projection = EventStore::Projection::Controls::Projection.example

  specify "SomeMessage" do
    some_message = EventStore::Projection::Controls::Message::SomeMessage.build
    projection.apply some_message, entity
    assert(entity.some_attribute == some_message.some_attribute)
  end

  specify "OtherMessage" do
    other_message = EventStore::Projection::Controls::Message::OtherMessage.build
    projection.apply other_message, entity
    assert(entity.some_time == other_message.some_time)
  end
end
