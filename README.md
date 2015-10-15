# Project

## Entity
```ruby
class SomeEntity
  attr_accessor :some_attribute
  attr_accessor :some_time
end
```

## Projection Definition
```ruby
class SomeEntityProjection
  include EventStore::EntityProjection

  apply SomeMessage do |message, entity|
    entity.some_attribute = message.some_attribute
  end

  apply OtherMessage do |message, entity|
    entity.some_time = message.some_time
  end
end
```

## Project Into an Entity
```ruby
entity = SomeEntity.new
SomeProjection.(entity, stream_name, starting_position: some_version)
```

## License

The `event_store-entity_projection` library is released under the [MIT License](https://github.com/obsidian-btc/event-store-entity-projection/blob/master/MIT-License.txt).
