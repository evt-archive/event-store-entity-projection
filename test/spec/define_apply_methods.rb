require_relative 'spec_init'

describe "Handler Macro" do
  projection = Projection::Controls::Projection.example

  describe "Handler Method Definitions" do
    specify "apply_some_message" do
      assert(projection.respond_to? :apply_some_message)
    end

    specify "apply_other_message" do
      assert(projection.respond_to? :apply_other_message)
    end
  end

  describe "Register Messages" do
    specify "SomeMessage" do
      projection.class.message_registry.registered? Projection::Controls::Message::SomeMessage
    end

    specify "OtherMessage" do
      projection.class.message_registry.registered? Projection::Controls::Message::OtherMessage
    end
  end
end
