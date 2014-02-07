class BusConfig
  def self.lookup(attribute)
    config_file[attribute]
  end

  def self.config_file
    YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "..", "config.yml"))
  end

  def self.database_config
    {adapter: 'postgres',
     host: lookup(:host),
     database: 'buses',
     username: lookup(:username), 
     password: lookup(:password)}
  end
end