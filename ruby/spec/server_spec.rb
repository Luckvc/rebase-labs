require 'spec_helper'
require 'pg'
require 'csv'
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
    test_data = CSV.read('spec/support/test_data.csv', col_sep: ';')
    allow(CSV).to receive(:read).and_return(test_data)

    import_from_csv
    
    get '/tests'

    expect(last_response.content_type).to eq 'application/json'

    json = JSON.parse(last_response.body)
    expect(json[0]['patient_cpf']).to eq '048.973.170-88'
    expect(json[0]['patient_name']).to eq 'Lucas Vasques'
    expect(json[0]['patient_email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(json[0]['patient_birthdate']).to eq '2001-03-11'
    expect(json[0]['patient_address']).to eq '165 Rua Rafaela'
    expect(json[0]['patient_city']).to eq 'Ituverava'
    expect(json[0]['patient_state']).to eq 'Alagoas'
    expect(json[0]['doctor_crm']).to eq 'B000BJ20J4'
    expect(json[0]['doctor_crm_state']).to eq 'PI'
    expect(json[0]['doctor_name']).to eq 'Maria Luisa Baos'
    expect(json[0]['doctor_email']).to eq 'denna@wisozk.biz'
    expect(json[0]['exam_token']).to eq 'IQCZ17'
    expect(json[0]['exam_date']).to eq '2021-08-05'
    expect(json[0]['exam_type']).to eq 'hemácias'
    expect(json[0]['exam_limits']).to eq '45-52'
    expect(json[0]['exam_result']).to eq '97'

    expect(json[1]['patient_cpf']).to eq '019.338.696-82'
    expect(json[1]['patient_name']).to eq 'Frederico Mozzato'
    expect(json[1]['patient_email']).to eq 'leona@bahringer.net'
    expect(json[1]['patient_birthdate']).to eq '1978-01-26'
    expect(json[1]['patient_address']).to eq 's/n Marginal Eloah Dantas'
    expect(json[1]['patient_city']).to eq 'Serra Negra do Norte'
    expect(json[1]['patient_state']).to eq 'Santa Catarina'
    expect(json[1]['doctor_crm']).to eq 'B0002W2RBG'
    expect(json[1]['doctor_crm_state']).to eq 'CE'
    expect(json[1]['doctor_name']).to eq 'Dr. Rafael'
    expect(json[1]['doctor_email']).to eq 'diann_klein@schinner.org'
    expect(json[1]['exam_token']).to eq 'Z95COQ'
    expect(json[1]['exam_date']).to eq '2021-04-29'
    expect(json[1]['exam_type']).to eq 'ácido úrico'
    expect(json[1]['exam_limits']).to eq '15-61'
    expect(json[1]['exam_result']).to eq '52'

    expect(json[2]['patient_cpf']).to eq '089.034.562-70'
    expect(json[2]['patient_name']).to eq 'Paulo Henrique'
    expect(json[2]['patient_email']).to eq 'herta_wehner@krajcik.name'
    expect(json[2]['patient_birthdate']).to eq '1998-02-25'
    expect(json[2]['patient_address']).to eq '5334 Rodovia Thiago Bittencourt'
    expect(json[2]['patient_city']).to eq 'Jequitibá'
    expect(json[2]['patient_state']).to eq 'Paraná'
    expect(json[2]['doctor_crm']).to eq 'B0002W2RBG'
    expect(json[2]['doctor_crm_state']).to eq 'CE'
    expect(json[2]['doctor_name']).to eq 'Dr. Leandro'
    expect(json[2]['doctor_email']).to eq 'diann_klein@schinner.org'
    expect(json[2]['exam_token']).to eq '0B5XII'
    expect(json[2]['exam_date']).to eq '2021-07-15'
    expect(json[2]['exam_type']).to eq 'ldl'
    expect(json[2]['exam_limits']).to eq '45-54'
    expect(json[2]['exam_result']).to eq '48'
  end
end