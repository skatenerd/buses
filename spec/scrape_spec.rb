require 'rspec'
require 'scrape'


describe Scrape do
  it "scrapes" do
    Net::HTTP.stub(get: "yo")
    puts "HI"
  end
end
