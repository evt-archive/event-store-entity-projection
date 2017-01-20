require_relative 'bench_init'

context "Project Messages from a Stream that Doesn't Exist" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get 'testStreamNotFound'

  entity = EventStore::EntityProjection::Controls::Entity.example

  projection = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection.build entity

  event_number = nil

  read = EventSource::EventStore::HTTP::Read.build stream_name, position: 0, batch_size: 1
  read.() do |event_data|
    projection.(event_data)
    event_number = event_data.position
  end

  comment "Last Event Number: #{event_number}"

  context "Entity Attributes Are Not Set" do
    test "some_attribute" do
      assert(entity.some_attribute.nil?)
    end

    test "some_time" do
      assert(entity.some_time.nil?)
    end
  end

  test "Version is not set" do
    assert(event_number.nil?)
  end
end
