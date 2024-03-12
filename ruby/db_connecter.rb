require 'pg'

class DBConnecter
  def self.connect
    dbname = ENV['RACK_ENV'] || 'development'
    PG.connect(dbname: dbname, host: 'postgres', user: 'admin', password: '123456')
  end
end