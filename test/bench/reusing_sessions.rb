require_relative './bench_init'

context "Reusing Sessions for Subsequent Projections" do
  stream_name = EventStore::EntityProjection::Controls::StreamName.get

  projection_cls = EventStore::EntityProjection::Controls::EntityProjection::SomeProjection
  session = EventStore::Client::HTTP::Session.build
  sink = Connection::Client.register_telemetry_sink session.connection

  test do
    entity = EventStore::EntityProjection::Controls::Entity.example

    projection_cls.(entity, stream_name, session: session)

    assert sink, &:written?
  end
end
