require 'dm-core'
require 'dm-migrations'
require_relative './bus_config'

class Models
  class Prediction
    include DataMapper::Resource
    storage_names[:default] = "predictions"
    property :id, Serial
    belongs_to :snapshot
    property :minutes, Integer
    property :vehicle_number, Integer
  end

  class Snapshot
    include DataMapper::Resource
    storage_names[:default] = "snapshots"
    property :id, Serial
    property :stop_number, Integer
    has n, :predictions
    property :created_at, DateTime
  end

  def self.configure
    DataMapper.setup(:default, BusConfig.database_config)
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
end
