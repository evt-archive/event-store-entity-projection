module EventStore
  module EntityProjection
    class Log < ::Log
      def tag!(tags)
        tags << :event_store_entity_projection
        tags << :entity_projection
        tags << :library
      end
    end
  end
end
