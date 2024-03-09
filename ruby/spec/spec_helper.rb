require 'rack/test'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:all) do
    @conn = PG.connect(dbname: 'test', host: 'postgres', user: 'admin', password: '123456')
    @conn.exec("TRUNCATE TABLE patients, doctors, exams, tests;")
  end

  config.after(:all) do
    @conn.close
  end
  
  config.after(:each) do
    @conn.exec("TRUNCATE TABLE patients, doctors, exams, tests;")
  end
end
