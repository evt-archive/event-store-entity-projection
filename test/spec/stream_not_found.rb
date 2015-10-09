require_relative 'spec_init'

describe "Project Messages from a Stream that Doesn't Exist" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get 'testStreamNotFound'

  entity = EventStore::EntityProjection::Controls::Entity.example

  event_number = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.(entity, stream_name)

  logger(__FILE__).info "Last Event Number: #{event_number}"

  describe "Entity Attributes Are Not Set" do
    specify "some_attribute" do
      assert(entity.some_attribute.nil?)
    end

    specify "some_time" do
      assert(entity.some_time.nil?)
    end
  end

  specify "Version is not set" do
    assert(event_number.nil?)
  end
end
