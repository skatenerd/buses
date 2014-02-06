require 'rspec'
require 'dm-core'
require 'dm-migrations'
require 'models'

RSpec.configure do |_|
  DataMapper.setup(:default, {adapter: 'postgres', host: 'localhost', database: 'buses', username: 'postgres'})
  DataMapper.finalize
  DataMapper.auto_migrate!
end
