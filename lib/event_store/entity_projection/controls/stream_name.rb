module EventStore
  module EntityProjection
    module Controls
      module StreamName
        def self.get(category=nil)
          ::Messaging::Controls::StreamName.example category: category
        end
      end
    end
  end
end
