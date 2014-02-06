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
  end

  it "scrapes minutes" do
    Net::HTTP.stub(get: XML_RESPONSE)

    Scrape.execute
    Models::Snapshot.count.should == 1
    predictions = Models::Snapshot.first.predictions
    predictions.first.minutes.should == 10
    predictions.last.minutes.should == 28
  end

  it "scrapes vehicle numbers" do
    Net::HTTP.stub(get: XML_RESPONSE)

    Scrape.execute
    predictions = Models::Snapshot.first.predictions
    predictions.first.vehicle_number.should == 1888
  end
end
