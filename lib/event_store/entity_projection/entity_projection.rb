module EventStore
  module EntityProjection
    def self.included(cls)
      cls.class_exec do
        include Log::Dependency
        include ::EntityProjection
      end
    end

    def apply(message)
      handle_message message
    end
  end
end
