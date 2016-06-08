module EventStore
  module EntityProjection
    module Controls
      module EntityProjection
        class SomeProjection
          include EventStore::EntityProjection
          include EventStore::EntityProjection::Controls::Message

          entity_name :some_entity

          apply SomeMessage do |message|
            entity.some_attribute = message.some_attribute
          end

          apply OtherMessage do |message|
            entity.some_time = message.some_time
          end
        end

        def self.example
          SomeProjection.new(Entity.example)
        end
      end
    end
  end
end
