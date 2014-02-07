require 'bus_config'

describe BusConfig do
  it "defaults to example config if there is no config file" do
    YAML.stub(:load_file) do |path|
      if path.match("example")
        {foo: 22}
      else
        raise("ITS NOT THERE")
      end
    end

    BusConfig.lookup(:foo).should == 22
  end

  it "prioritizes a config.yml if it exists" do
    YAML.stub(:load_file) do |path|
      if path.match("example")
        {foo: 22}
      else
        {foo: "WIN"}
      end
    end
    BusConfig.lookup(:foo).should == "WIN"
  end
end
