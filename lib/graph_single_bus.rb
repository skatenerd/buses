require 'models'

class GraphSingleBus
  def self.for_bus(bus_number)
    latest = Models::Snapshot.last(
      Models::Snapshot.predictions.vehicle_number => bus_number
    )

    latest_time = latest.created_at
    time_threshold = latest_time - (30.0 / (24.0 * 60.0))

    Models::Snapshot.all(
      Models::Snapshot.predictions.vehicle_number => 1,
      :created_at.gte => time_threshold,
      :order => [:created_at.asc]
    )
  end
end
