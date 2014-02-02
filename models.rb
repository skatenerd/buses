require 'dm-core'
require 'dm-migrations'

class Models
  class Prediction
    include DataMapper::Resource
    storage_names[:default] = "predictions"
    property :id, Serial
    belongs_to :snapshot
    property :minutes, Integer
  end

  class Snapshot
    include DataMapper::Resource
    storage_names[:default] = "snapshots"
    property :id, Serial
    has n, :predictions
    property :created_at, DateTime
  end

  def self.config_file
    YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "config.yml"))
  end

  def self.username
    config_file[:username]
  end

  def self.password
    config_file[:password]
  end

  def self.host
    config_file[:host]
  end

  def self.configure
    DataMapper.setup(:default, {adapter: 'postgres', host: host, database: 'buses', username: username, password: password})
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
end
