require 'spec_helper'
require 'csv'
require_relative '../data_importer'
require_relative '../server'
require 'require_all'
require_all 'models'


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
    DataImporter.import_from_csv(test_data)
    
    get '/tests'

    expect(last_response.content_type).to eq 'application/json'

    json = JSON.parse(last_response.body)
    expect(json[0]['token']).to eq 'IQCZ17'
    expect(json[0]['date']).to eq '2021-08-05'
    expect(json[0]['patient']['cpf']).to eq '048.973.170-88'
    expect(json[0]['patient']['name']).to eq 'Lucas Vasques'
    expect(json[0]['patient']['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(json[0]['patient']['birthdate']).to eq '2001-03-11'
    expect(json[0]['patient']['address']).to eq '165 Rua Rafaela'
    expect(json[0]['patient']['city']).to eq 'Ituverava'
    expect(json[0]['patient']['state']).to eq 'Alagoas'
    expect(json[0]['doctor']['crm']).to eq 'B000BJ20J4'
    expect(json[0]['doctor']['crm_state']).to eq 'PI'
    expect(json[0]['doctor']['name']).to eq 'Maria Luisa Baos'
    expect(json[0]['doctor']['email']).to eq 'denna@wisozk.biz'
    expect(json[0]['tests'][0]['type']).to eq 'hemácias'
    expect(json[0]['tests'][0]['limits']).to eq '45-52'
    expect(json[0]['tests'][0]['result']).to eq '97'

    expect(json[1]['token']).to eq 'Z95COQ'
    expect(json[1]['date']).to eq '2021-04-29'
    expect(json[1]['patient']['cpf']).to eq '019.338.696-82'
    expect(json[1]['patient']['name']).to eq 'Frederico Mozzato'
    expect(json[1]['patient']['email']).to eq 'leona@bahringer.net'
    expect(json[1]['patient']['birthdate']).to eq '1978-01-26'
    expect(json[1]['patient']['address']).to eq 's/n Marginal Eloah Dantas'
    expect(json[1]['patient']['city']).to eq 'Serra Negra do Norte'
    expect(json[1]['patient']['state']).to eq 'Santa Catarina'
    expect(json[1]['doctor']['crm']).to eq 'B0002W2RBG'
    expect(json[1]['doctor']['crm_state']).to eq 'PE'
    expect(json[1]['doctor']['name']).to eq 'Dr. Rafael'
    expect(json[1]['doctor']['email']).to eq 'diann_klein@schinner.org'
    expect(json[1]['tests'][0]['type']).to eq 'ácido úrico'
    expect(json[1]['tests'][0]['limits']).to eq '15-61'
    expect(json[1]['tests'][0]['result']).to eq '52'

    expect(json[2]['token']).to eq '0B5XII'
    expect(json[2]['date']).to eq '2021-07-15'
    expect(json[2]['patient']['cpf']).to eq '089.034.562-70'
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
      patient = Patient.create({cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                state:'SP'}, @conn)
      doctor = Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)
      exam = Exam.create({token: 'IG4O21', date: Date.new(2024, 01, 12), patient_id: patient.id, doctor_id: doctor.id}, @conn)
      Exam.create({token: 'PG248G', date: Date.new(2023, 11, 18), patient_id: patient.id, doctor_id: doctor.id}, @conn)

      exam.create_test({type: 'hemácias', limits: '45-52', result: '97'}, @conn)
      exam.create_test({type: 'leucócitos', limits: '9-61', result: '89'}, @conn)

      get '/tests/IG4O21'

      expect(last_response.content_type).to eq 'application/json'

      json = JSON.parse(last_response.body)
      expect(json['token']).to eq 'IG4O21'
      expect(json['date']).to eq '2024-01-12'
      expect(json['patient']['cpf']).to eq '12345678912'
      expect(json['patient']['name']).to eq 'Lucas Vasques'
      expect(json['patient']['email']).to eq 'lucas@email.com'
      expect(json['patient']['birthdate']).to eq '2000-11-08'
      expect(json['patient']['address']).to eq 'Rua Silva e Silva'
      expect(json['patient']['city']).to eq 'São Paulo'
      expect(json['patient']['state']).to eq 'SP'
      expect(json['doctor']['crm']).to eq '654321'
      expect(json['doctor']['crm_state']).to eq 'CE'
      expect(json['doctor']['name']).to eq 'Leonardo Silva'
      expect(json['doctor']['email']).to eq 'leo@email.com'
      expect(json['tests'][0]['type']).to eq 'hemácias'
      expect(json['tests'][0]['limits']).to eq '45-52'
      expect(json['tests'][0]['result']).to eq '97'
      expect(json['tests'][1]['type']).to eq 'leucócitos'
      expect(json['tests'][1]['limits']).to eq '9-61'
      expect(json['tests'][1]['result']).to eq '89'
    end
    
    it 'not found' do
      get '/tests/Z9OFOQ'

      expect(last_response.body).to be {}
    end
  end

  context '/import' do
    it 'success' do
      post '/import', "file" => Rack::Test::UploadedFile.new("spec/support/test_data.csv", "text/csv")

      expect(last_response.status).to eq 200
      expect(Patient.all(@conn).count).to eq 3
      expect(Exam.all(@conn).count).to eq 3
      expect(Doctor.all(@conn).count).to eq 3
      expect(Test.all(@conn).count).to eq 3
    end

    it 'not a supported file' do
      post '/import', "file" => Rack::Test::UploadedFile.new("spec/support/image.png", "text/csv")

      expect(last_response.status).to eq 415
      expect(last_response.body).to include 'Arquivo não suportado'
    end
    
    it 'a csv with the wrong data' do
      post '/import', "file" => Rack::Test::UploadedFile.new("spec/support/wrong_test_data.csv", "text/csv")

      expect(last_response.status).to eq 422
      expect(last_response.body).to include 'Dados não compatíveis'
    end
  end
end