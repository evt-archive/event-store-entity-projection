require_relative 'spec_init'

describe "Apply Messages" do
  entity = Projection::Controls::Entity.example

  projection = Projection::Controls::Projection.example

  other_message = Projection::Controls::Message::OtherMessage.build

  specify "SomeMessage" do
    some_message = Projection::Controls::Message::SomeMessage.build

    projection.apply some_message, entity

    assert(entity.some_attribute == some_message.some_attribute)
  end
end
