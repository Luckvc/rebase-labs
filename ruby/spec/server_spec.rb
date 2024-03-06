require 'spec_helper'
require 'sinatra'

describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it '/hello' do
    get '/hello'

    expect(last_response.body).to include 'Hello World'
  end
end