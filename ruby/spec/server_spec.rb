require 'spec_helper'
require 'pg'
require 'byebug'
require_relative '../test_import_from_csv'
require_relative '../server'


describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it '/hello' do
    get '/hello'

    expect(last_response.body).to include 'Hello world!'
  end

  it '/tests' do
    import_from_csv
    
    get '/tests'

    expect(last_response.content_type).to eq 'application/json'

    json = JSON.parse(last_response.body)
    expect(json[0]['patient_cpf']).to eq '048.973.170-88'
    expect(json[0]['patient_name']).to eq 'Emilly Batista Neto'
    expect(json[0]['patient_email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(json[0]['patient_birthdate']).to eq '2001-03-11'
    expect(json[0]['patient_address']).to eq '165 Rua Rafaela'
    expect(json[0]['patient_city']).to eq 'Ituverava'
    expect(json[0]['patient_state']).to eq 'Alagoas'
    expect(json[0]['doctor_crm']).to eq 'B000BJ20J4'
    expect(json[0]['doctor_crm_state']).to eq 'PI'
    expect(json[0]['doctor_name']).to eq 'Maria Luiza Pires'
    expect(json[0]['doctor_email']).to eq 'denna@wisozk.biz'
    expect(json[0]['exam_token']).to eq 'IQCZ17'
    expect(json[0]['exam_date']).to eq '2021-08-05'
    expect(json[0]['exam_type']).to eq 'hemácias'
    expect(json[0]['exam_limits']).to eq '45-52'
    expect(json[0]['exam_result']).to eq '97'

    expect(json[1]['patient_cpf']).to eq '048.973.170-88'
    expect(json[1]['patient_name']).to eq 'Emilly Batista Neto'
    expect(json[1]['patient_email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(json[1]['patient_birthdate']).to eq '2001-03-11'
    expect(json[1]['patient_address']).to eq '165 Rua Rafaela'
    expect(json[1]['patient_city']).to eq 'Ituverava'
    expect(json[1]['patient_state']).to eq 'Alagoas'
    expect(json[1]['doctor_crm']).to eq 'B000BJ20J4'
    expect(json[1]['doctor_crm_state']).to eq 'PI'
    expect(json[1]['doctor_name']).to eq 'Maria Luiza Pires'
    expect(json[1]['doctor_email']).to eq 'denna@wisozk.biz'
    expect(json[1]['exam_token']).to eq 'IQCZ17'
    expect(json[1]['exam_date']).to eq '2021-08-05'
    expect(json[1]['exam_type']).to eq 'leucócitos'
    expect(json[1]['exam_limits']).to eq '9-61'
    expect(json[1]['exam_result']).to eq '89'

    expect(json[2]['patient_cpf']).to eq '048.973.170-88'
    expect(json[2]['patient_name']).to eq 'Emilly Batista Neto'
    expect(json[2]['patient_email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(json[2]['patient_birthdate']).to eq '2001-03-11'
    expect(json[2]['patient_address']).to eq '165 Rua Rafaela'
    expect(json[2]['patient_city']).to eq 'Ituverava'
    expect(json[2]['patient_state']).to eq 'Alagoas'
    expect(json[2]['doctor_crm']).to eq 'B000BJ20J4'
    expect(json[2]['doctor_crm_state']).to eq 'PI'
    expect(json[2]['doctor_name']).to eq 'Maria Luiza Pires'
    expect(json[2]['doctor_email']).to eq 'denna@wisozk.biz'
    expect(json[2]['exam_token']).to eq 'IQCZ17'
    expect(json[2]['exam_date']).to eq '2021-08-05'
    expect(json[2]['exam_type']).to eq 'plaquetas'
    expect(json[2]['exam_limits']).to eq '11-93'
  end
end