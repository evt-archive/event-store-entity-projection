# Project

## Entity
class SomeEntity
  attr_accessor :some_attribute
  attr_accessor :some_time
end

## Projection Definition
class SomeEntityProjection
  include EventStore::EntityProjection

  apply SomeMessage do |message, entity|
    entity.some_attribute = message.some_attribute
  end

  apply OtherMessage do |message, entity|
    entity.some_time = message.some_time
  end
end

## Project Into an Entity

entity = SomeEntity.new
SomeProjection.! entity, stream_name, starting_position: entity.version
