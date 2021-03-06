require_relative 'bench_init'

context "Apply Messages" do
  entity = EventStore::EntityProjection::Controls::Entity.example

  projection = EventStore::EntityProjection::Controls::EntityProjection.example

  test "SomeMessage" do
    some_message = EventStore::EntityProjection::Controls::Message::SomeMessage.build    # projection.apply some_message, entity
    projection.apply some_message
    assert(entity.some_attribute == some_message.some_attribute)
  end

  test "OtherMessage" do
    other_message = EventStore::EntityProjection::Controls::Message::OtherMessage.build
    projection.apply other_message
    assert(entity.some_time == other_message.some_time)
  end
end
