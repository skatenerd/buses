require 'nokogiri'
require 'net/http'
require_relative './models'
require_relative './bus_config'

class Scrape
  def self.stop_url(stop_number)
    "http://www.ctabustracker.com/bustime/map/getStopPredictions.jsp?eta=true&route=all&stop=#{stop_number}"
  end

  def self.scrape_single_stop(stop_number)
    raw = Net::HTTP.get(URI(stop_url(stop_number)))

    prediction_nodes = Nokogiri.parse(raw).css("stop pre")

    predictions = prediction_nodes.map do |prediction|
      minutes = prediction.css("pt").text
      vehicle_number = prediction.css("v").text
      route_number = prediction.css("rn").text
      Models::Prediction.new(
        minutes: minutes,
        vehicle_number: vehicle_number,
        route_number: route_number
      )
    end

    Models::Snapshot.create(
      created_at: DateTime.now,
      predictions: predictions,
      stop_number: stop_number
      )
  end

  def self.stops
    BusConfig.lookup(:stop_numbers)
  end

  def self.scrape_every_stop
    stops.each do |stop|
      scrape_single_stop(stop)
    end
  end
end

if __FILE__ == $0
  Models.configure
  Scrape.scrape_every_stop
end
