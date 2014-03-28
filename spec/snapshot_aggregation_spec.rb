require 'rspec'
require 'snapshot_aggregation'

describe SnapshotAggregation do
  it "finds latest snapshot for bus number, and all of its snapshots up to 2 hrs beforehand" do
    now = DateTime.now
    latest = Models::Snapshot.create(
      created_at: now,
      predictions: [Models::Prediction.new(vehicle_number: 1)]
    )

    many_minutes_ago = Models::Snapshot.create(
      created_at: now - minutes(28),
      predictions: [Models::Prediction.new(vehicle_number: 1)]
    )

    recently = Models::Snapshot.create(
      created_at: now - minutes(2),
      predictions: [Models::Prediction.new(vehicle_number: 1)]
    )

    other_bus = Models::Snapshot.create(
      created_at: now - minutes(5),
      predictions: [Models::Prediction.new(vehicle_number: 777)]
    )
    SnapshotAggregation.snapshots_for_bus(1).should== [
      many_minutes_ago,
      recently,
      latest
    ]
  end
end

