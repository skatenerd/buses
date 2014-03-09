require 'gruff'
require_relative './models'

class GraphScatter
  attr_reader :x_values, :y_values, :stop_number

  def initialize(stop_number)
    @stop_number = stop_number
    get_points
  end

  def get_points
    snapshots = Models::Snapshot.last(50, {
      stop_number: stop_number
    }).sort_by(&:created_at)

    initial_time = snapshots.first.created_at

    point_clusters = snapshots.map do |snapshot|
      difference = (snapshot.created_at - initial_time) * 24 * 60
      snapshot.predictions.map do |prediction|
        [difference, prediction.minutes]
      end
    end

    points = point_clusters.reduce(&:+)

    @x_values = points.map(&:first)
    @y_values = points.map(&:last)
  end

  def run!
    g = Gruff::Scatter.new
    g.title = "Predicted Bus Arrival Times.\nX axis: elapsed minutes,\nY axis: estimated time before bus arrives"
    g.data("Stop #{stop_number}:  ", x_values, y_values)
    g.write("artifacts/#{stop_number}.png")
  end
end


if __FILE__ == $0
  Models.configure
  stop_number = ARGV[0].to_i
  scatter = GraphScatter.new(stop_number)
  scatter.run!
end
