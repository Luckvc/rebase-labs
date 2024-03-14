# frozen_string_literal: true

require 'pg'

class DBConnecterService
  def self.connect
    dbname = ENV['RACK_ENV'] || 'development'
    PG.connect(dbname:, host: 'postgres', user: 'admin', password: '123456')
  end
end
