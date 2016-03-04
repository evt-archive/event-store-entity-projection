require_relative 'bench_init'

context "Apply Macro" do
  projection = EventStore::EntityProjection::Controls::EntityProjection.example

  context "Handler Method Definitions" do
    test "apply_some_message" do
      assert(projection.respond_to? :apply_some_message)
    end

    test "apply_other_message" do
      assert(projection.respond_to? :apply_other_message)
    end
  end

  context "Register Messages" do
    test "SomeMessage" do
      projection.class.message_registry.registered? EventStore::EntityProjection::Controls::Message::SomeMessage
    end

    test "OtherMessage" do
      projection.class.message_registry.registered? EventStore::EntityProjection::Controls::Message::OtherMessage
    end
  end
end
