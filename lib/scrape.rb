require 'nokogiri'
require 'net/http'
require_relative './models'

class Scrape
  def self.execute
    Models.configure

    raw = Net::HTTP.get(URI("http://www.ctabustracker.com/bustime/map/getStopPredictions.jsp?eta=true&route=all&stop=1327"))

    prediction_times = Nokogiri.parse(raw).css("stop pre pt").map do |node|
      node.children.first.text.to_i
    end

    Models::Snapshot.create(
      created_at: Time.now,
      predictions: prediction_times.map {|t| Models::Prediction.new(minutes: t)}
    )
  end
end

if __FILE__ == $0
    Scrape.execute
end
