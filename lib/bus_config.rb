class BusConfig
  def self.lookup(attribute)
    config_file[attribute]
  end

  def self.path_in_root_direcotry(filename)
    File.join(File.expand_path(File.dirname(__FILE__)), "..", filename)
  end

  def self.config_file
    YAML.load_file(path_in_root_direcotry("config.yml"))
  rescue
    YAML.load_file(path_in_root_direcotry("config.example.yml"))
  end

  def self.database_config
    {adapter: 'postgres',
     host: lookup(:host),
     database: 'buses',
     username: lookup(:username),
     password: lookup(:password)}
  end
end
