module EventStore
  module EntityProjection
    module Controls
      module EntityProjection
        class SomeProjection
          include EventStore::EntityProjection
          include EventStore::EntityProjection::Controls::Message

          entity_name :some_entity

          apply SomeMessage do |some_message|
            some_entity.some_attribute = some_message.some_attribute
          end

          apply OtherMessage do |other_message|
            some_entity.some_time = other_message.some_time
          end
        end

        def self.example
          SomeProjection.new(Entity.example)
        end
      end
    end
  end
end
