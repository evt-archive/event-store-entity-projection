require_relative 'bench_init'

context "Entity Name Macro" do
  projection = EventStore::EntityProjection::Controls::EntityProjection.example

  test "Defines named entity accessor" do
    assert(projection.respond_to? :some_entity)
  end

  test "Accesses the entity" do
    assert(projection.some_entity == projection.entity)
  end
end
