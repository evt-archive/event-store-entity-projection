module EventStore
  module EntityProjection
    module Controls
      module StreamName
        def self.get(category=nil)
          EventStore::Client::HTTP::Controls::StreamName.get category: category
        end
      end
    end
  end
end
