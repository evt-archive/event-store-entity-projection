module Projection
  module Controls
    module Projection
      class SomeEntityProjection
        include ::Projection
        include ::Projection::Controls::Message

        apply SomeMessage do |message, entity|
          logger.data message.inspect
          logger.data entity.inspect
        end

        apply OtherMessage do |message, entity|
          logger.data message.inspect
          logger.data entity.inspect
        end
      end

      def self.example
        SomeEntityProjection.new
      end
    end
  end
end
