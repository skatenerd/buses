require 'rspec'
require 'spec_helper'
require 'scrape'

XML_RESPONSE = <<-EOS
<stop>
  <pre>
    <pt>10</pt>
    <pu>MINUTES</pu>
    <fd>Grand/Nordica</fd>
    <v>1888</v>
    <rn>74</rn>
  </pre>
  <pre>
    <pt>28</pt>
    <pu>MINUTES</pu>
    <fd>Grand/Nordica</fd>
    <v>1075</v>
    <rn>74</rn>
  </pre>
</stop>
EOS


describe Scrape do
  before(:each) do
    DataMapper.auto_migrate!
    Net::HTTP.stub(get: XML_RESPONSE)
  end

  it "scrapes minutes" do
    Scrape.scrape_single_stop(1)
    Models::Snapshot.count.should == 1
    predictions = Models::Snapshot.first.predictions
    predictions.first.minutes.should == 10
    predictions.last.minutes.should == 28
  end

  it "scrapes vehicle numbers" do
    Scrape.scrape_single_stop(1)
    predictions = Models::Snapshot.first.predictions
    predictions.first.vehicle_number.should == 1888
  end

  it "scrapes route numbers" do
    Scrape.scrape_single_stop(1)
    predictions = Models::Snapshot.first.predictions
    predictions.first.route_number.should == 74
  end

  it "scrapes a url corresponding to provided stop number" do
    stop_number = 666
    Net::HTTP.should_receive(:get).with do |url|
      url.to_s.should match(stop_number.to_s)
    end.and_return(XML_RESPONSE)
    Scrape.scrape_single_stop(stop_number)
    Models::Snapshot.all({stop_number: stop_number}).should_not be_empty
  end

  it "runs for each stop number in the config" do
    BusConfig.stub(:lookup).with(:stop_numbers).and_return([1,2,3])
    Scrape.scrape_every_stop
    Models::Snapshot.all.map(&:stop_number).should== [1,2,3]
  end
end
