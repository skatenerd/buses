require 'gruff'
require_relative './models'

Models.configure

snapshots = Models::Snapshot.last(50).sort_by(&:created_at)

initial_time = snapshots.first.created_at

point_clusters = snapshots.map do |snapshot|
  difference = (snapshot.created_at - initial_time) * 24 * 60
  snapshot.predictions.map do |prediction|
    [difference, prediction.minutes]
  end
end

points = point_clusters.reduce(&:+)

x_values = points.map(&:first)
y_values = points.map(&:last)

g = Gruff::Scatter.new
g.title = "hokay"
g.data("bus stuff", x_values, y_values)
g.write("out.png")
