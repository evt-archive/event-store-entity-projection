module Projection
  module Controls
    module Projection
      class SomeEntityProjection
        include ::Projection
        include ::Projection::Controls::Message

        apply SomeMessage do |message, entity|
          entity.some_attribute = message.some_attribute
        end

        apply OtherMessage do |message, entity|
          entity.some_time = message.some_time
        end
      end

      def self.example
        SomeEntityProjection.new
      end
    end
  end
end
