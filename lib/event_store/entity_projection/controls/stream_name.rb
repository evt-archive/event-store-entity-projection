module EventStore
  module EntityProjection
    module Controls
      module StreamName
        def self.get(category=nil, id=nil, random: nil)
          if id.nil? && random.nil?
            EventStore::Client::HTTP::Controls::StreamName.get category: category
          else
            fail
          end
        end
      end
    end
  end
end
