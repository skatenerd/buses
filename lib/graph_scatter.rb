require 'gruff'
require_relative './models'

class GraphScatter
  attr_reader :x_values, :y_values, :stop_number

  def initialize(stop_number)
    @stop_number = stop_number
    get_points
  end

  def update_for_snapshot(bus_paths, snapshot, initial_time)
    snapshot.predictions.reduce(bus_paths) do |bus_paths, prediction|
      vehicle_number = prediction.vehicle_number
      bus_paths[vehicle_number] ||= []
      difference = (snapshot.created_at - initial_time) * 24 * 60
      bus_paths[vehicle_number] << [difference, prediction.minutes]
      bus_paths
    end
  end

  def get_points
    snapshots = Models::Snapshot.last(50, {
      stop_number: stop_number
    }).sort_by(&:created_at)

    initial_time = snapshots.first.created_at

    bus_paths = snapshots.reduce({}) do |bus_paths, snapshot|
      bus_paths = update_for_snapshot(bus_paths, snapshot, initial_time)
    end
    return bus_paths
  end

  def run!
    g = Gruff::Scatter.new
    g.title = "Predicted Bus Arrival Times.\nX axis: elapsed minutes,\nY axis: estimated time before bus arrives"
    get_points.each do |vehicle_number, points|
      g.data("Bus: #{vehicle_number}:  ", points.map(&:first), points.map(&:last))
    end
    g.write("artifacts/#{stop_number}.png")
  end
end


if __FILE__ == $0
  Models.configure
  stop_number = ARGV[0].to_i
  scatter = GraphScatter.new(stop_number)
  scatter.run!
end
