require 'rspec'
require 'spec_helper'
require 'graph_single_bus'

describe GraphSingleBus do
  before(:each) do
    DataMapper.auto_migrate!
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

