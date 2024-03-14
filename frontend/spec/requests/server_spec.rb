require 'spec_helper'
require 'csv'
require_relative '../../server'



describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it '/tests' do
    test_data = JSON.load_file('spec/support/test_data.json')
    fake_response = double('Faraday::Response', body: test_data.to_json)
    allow(Faraday).to receive(:get).and_return(fake_response)

    get '/tests'

    expect(last_response.content_type).to eq 'application/json'

    json = JSON.parse(last_response.body)
    expect(json[0]['token']).to eq 'IQ1457'
    expect(json[0]['date']).to eq '2021-08-05'
    expect(json[0]['patient']['cpf']).to eq '048.343.170-88'
    expect(json[0]['patient']['name']).to eq 'Lucas Vasques'
    expect(json[0]['patient']['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(json[0]['patient']['birthdate']).to eq '2001-03-11'
    expect(json[0]['patient']['address']).to eq '165 Rua Rafaela'
    expect(json[0]['patient']['city']).to eq 'Ituverava'
    expect(json[0]['patient']['state']).to eq 'Alagoas'
    expect(json[0]['doctor']['crm']).to eq 'B123BJ20J4'
    expect(json[0]['doctor']['crm_state']).to eq 'PI'
    expect(json[0]['doctor']['name']).to eq 'Maria Luisa Baos'
    expect(json[0]['doctor']['email']).to eq 'denna@wisozk.biz'
    expect(json[0]['tests'][0]['type']).to eq 'hemácias'
    expect(json[0]['tests'][0]['limits']).to eq '45-52'
    expect(json[0]['tests'][0]['result']).to eq '97'

    expect(json[1]['token']).to eq 'Z9ZERQ'
    expect(json[1]['date']).to eq '2021-04-29'
    expect(json[1]['patient']['cpf']).to eq '011.431.696-82'
    expect(json[1]['patient']['name']).to eq 'Frederico Mozzato'
    expect(json[1]['patient']['email']).to eq 'leona@bahringer.net'
    expect(json[1]['patient']['birthdate']).to eq '1978-01-26'
    expect(json[1]['patient']['address']).to eq 's/n Marginal Eloah Dantas'
    expect(json[1]['patient']['city']).to eq 'Serra Negra do Norte'
    expect(json[1]['patient']['state']).to eq 'Santa Catarina'
    expect(json[1]['doctor']['crm']).to eq 'B1322W2RBG'
    expect(json[1]['doctor']['crm_state']).to eq 'PE'
    expect(json[1]['doctor']['name']).to eq 'Dr. Rafael'
    expect(json[1]['doctor']['email']).to eq 'diann_klein@schinner.org'
    expect(json[1]['tests'][0]['type']).to eq 'ácido úrico'
    expect(json[1]['tests'][0]['limits']).to eq '15-61'
    expect(json[1]['tests'][0]['result']).to eq '52'

    expect(json[2]['token']).to eq '0OXID'
    expect(json[2]['date']).to eq '2021-07-15'
    expect(json[2]['patient']['cpf']).to eq '089.125.562-70'
    expect(json[2]['patient']['name']).to eq 'Paulo Henrique'
    expect(json[2]['patient']['email']).to eq 'herta_wehner@krajcik.name'
    expect(json[2]['patient']['birthdate']).to eq '1998-02-25'
    expect(json[2]['patient']['address']).to eq '5334 Rodovia Thiago Bittencourt'
    expect(json[2]['patient']['city']).to eq 'Jequitibá'
    expect(json[2]['patient']['state']).to eq 'Paraná'
    expect(json[2]['doctor']['crm']).to eq 'B0002W2RBG'
    expect(json[2]['doctor']['crm_state']).to eq 'CE'
    expect(json[2]['doctor']['name']).to eq 'Dr. Leandro'
    expect(json[2]['doctor']['email']).to eq 'diann_klein@schinner.org'
    expect(json[2]['tests'][0]['type']).to eq 'ldl'
    expect(json[2]['tests'][0]['limits']).to eq '45-54'
    expect(json[2]['tests'][0]['result']).to eq '48'
  end

  context '/tests/:token' do
    it 'success' do
      single_exam_data = JSON.load_file('spec/support/single_exam_data.json')
      fake_response = double('Faraday::Response', body: single_exam_data.to_json)
      allow(Faraday).to receive(:get).and_return(fake_response)
  
      get '/tests'
  
      expect(last_response.content_type).to eq 'application/json'
  
      json = JSON.parse(last_response.body)
      expect(json['token']).to eq 'IQ1457'
      expect(json['date']).to eq '2021-08-05'
      expect(json['patient']['cpf']).to eq '048.343.170-88'
      expect(json['patient']['name']).to eq 'Lucas Vasques'
      expect(json['patient']['email']).to eq 'gerald.crona@ebert-quigley.com'
      expect(json['patient']['birthdate']).to eq '2001-03-11'
      expect(json['patient']['address']).to eq '165 Rua Rafaela'
      expect(json['patient']['city']).to eq 'Ituverava'
      expect(json['patient']['state']).to eq 'Alagoas'
      expect(json['doctor']['crm']).to eq 'B123BJ20J4'
      expect(json['doctor']['crm_state']).to eq 'PI'
      expect(json['doctor']['name']).to eq 'Maria Luisa Baos'
      expect(json['doctor']['email']).to eq 'denna@wisozk.biz'
      expect(json['tests'][0]['type']).to eq 'hemácias'
      expect(json['tests'][0]['limits']).to eq '45-52'
      expect(json['tests'][0]['result']).to eq '97'
    end
    
    it 'not found' do
      get '/tests/Z9OFOQ'

      expect(last_response.body).to be {}
    end
  end

  context '/import' do
    it 'success' do
      fake_faraday = double('Faraday::Connection')
      fake_response = double('Faraday::Response', body: "Sua requisição está sendo processada")
      allow(Faraday).to receive(:new).and_return(fake_faraday)
      allow(fake_faraday).to receive(:post).and_return(fake_response)

      post '/import', "file" => Rack::Test::UploadedFile.new("spec/support/test_data.csv", "text/csv")

      expect(last_response.body).to include 'Sua requisição está sendo processada'
    end

    it 'not a supported file' do
      fake_faraday = double('Faraday::Connection')
      fake_response = double('Faraday::Response', body: "Arquivo não suportado", status: 415)
      allow(Faraday).to receive(:new).and_return(fake_faraday)
      allow(fake_faraday).to receive(:post).and_return(fake_response)

      post '/import', "file" => Rack::Test::UploadedFile.new("spec/support/image.png", "text/csv")

      expect(last_response.status).to eq 415
      expect(last_response.body).to include 'Arquivo não suportado'
    end
  end
end