require 'nokogiri'
require 'net/http'
require 'models'

class Scrape
  def self.execute
    raw = Net::HTTP.get(URI("http://www.ctabustracker.com/bustime/map/getStopPredictions.jsp?eta=true&route=all&stop=1327"))


    prediction_nodes = Nokogiri.parse(raw).css("stop pre")

    predictions = prediction_nodes.map do |prediction|
      minutes = prediction.css("pt").text
      vehicle_number = prediction.css("v").text
      Models::Prediction.new(minutes: minutes, vehicle_number: vehicle_number)
    end

    Models::Snapshot.create(
      created_at: Time.now,
      predictions: predictions
    )
  end
end

if __FILE__ == $0
  Models.configure
  Scrape.execute
end
