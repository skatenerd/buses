require 'gruff'
require_relative './models'

class GraphSingleBus
  MINUTES_PER_DAY = 24.0 * 60.0

  def self.snapshots_for_bus(bus_number)
    latest = Models::Snapshot.last(
      Models::Snapshot.predictions.vehicle_number => bus_number
    )

    latest_time = latest.created_at
    time_threshold = latest_time - (30.0 / (24.0 * 60.0))

    Models::Snapshot.all(
      Models::Snapshot.predictions.vehicle_number => bus_number,
      :created_at.gte => time_threshold,
      :order => [:created_at.asc]
    )
  end

  def self.days_to_minutes(days)
    days * MINUTES_PER_DAY
  end

  def self.points_for_bus(bus_number)
    snapshots = snapshots_for_bus(bus_number)
    initial_time = snapshots.first.created_at
    snapshots.map do |snapshot|
      prediction_for_bus = snapshot.predictions.detect do |prediction|
        prediction.vehicle_number = bus_number
      end
      minutes = prediction_for_bus.minutes
      elapsed_time = days_to_minutes(snapshot.created_at - initial_time)
      [elapsed_time, minutes]
    end
  end
end

if __FILE__ == $0
  Models.configure
  random_bus = Models::Prediction.all(:vehicle_number.not => nil, :limit => 1000, :order => [:id.asc]).sample.vehicle_number

  points = GraphSingleBus.points_for_bus(random_bus)
  x_values = points.map(&:first)
  y_values = points.map(&:last)

  g = Gruff::Scatter.new
  g.title = "Predicted Bus Arrival Times.\nX axis: elapsed minutes,\nY axis: estimated time before bus arrives"
  g.data("Stop 1327, fullerton and sacramento, bus: #{random_bus}", x_values, y_values)
  g.write("artifacts/single_bus.png")
end
