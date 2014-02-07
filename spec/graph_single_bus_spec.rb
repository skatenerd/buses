require 'rspec'
require 'spec_helper'
require 'graph_single_bus'

describe GraphSingleBus do
  before(:each) do
    DataMapper.auto_migrate!
  end

  def minutes(how_many)
    how_many / (24.0 * 60.0)
  end

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
    GraphSingleBus.snapshots_for_bus(1).should== [
      many_minutes_ago,
      recently,
      latest
    ]
  end

  it "computes points to plot from bus number and collection of snapshots" do
    now = DateTime.now
    long_ago = Models::Snapshot.create(
      created_at: now - minutes(10),
      predictions: [
        Models::Prediction.new(vehicle_number: 1, minutes: 100),
        Models::Prediction.new(vehicle_number: 2, minutes: 100)
      ]
    )
    recently = Models::Snapshot.create(
      created_at: now - minutes(5),
      predictions: [
        Models::Prediction.new(vehicle_number: 1, minutes: 50)
      ]
    )

    GraphSingleBus.points_for_bus(1).should == [[0, 100], [5, 50]]
  end

end

