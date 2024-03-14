# frozen_string_literal: true

require 'spec_helper'
require 'require_all'
require_all 'models'

RSpec.describe Patient, type: :model do
  context '#all' do
    it 'return array with every instance in database' do
      Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                       birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                       state: 'SP' }, @conn)
      Patient.create({ cpf: '54621387954', name: 'Juliana Moedas', email: 'juliana@email.com',
                       birthdate: Date.new(1985, 5, 18), address: 'Rua Carvalho', city: 'Rio de Janeiro',
                       state: 'RJ' }, @conn)
      Patient.create({ cpf: '98765432112', name: 'Roberto Marcos', email: 'roberto@email.com',
                       birthdate: Date.new(2000, 8, 4), address: 'Rua da Praia', city: 'Recife', state: 'PE' }, @conn)

      result = Patient.all(@conn)

      expect(result.count).to eq 3
      expect(result[0].cpf).to eq '12345678912'
      expect(result[0].name).to eq 'Lucas Vasques'
      expect(result[0].email).to eq 'lucas@email.com'
      expect(result[0].birthdate).to eq '1995-11-08'
      expect(result[0].address).to eq 'Rua Silva e Silva'
      expect(result[0].city).to eq 'São Paulo'
      expect(result[0].state).to eq 'SP'

      expect(result[1].cpf).to eq '54621387954'
      expect(result[1].name).to eq 'Juliana Moedas'
      expect(result[1].email).to eq 'juliana@email.com'
      expect(result[1].birthdate).to eq '1985-05-18'
      expect(result[1].address).to eq 'Rua Carvalho'
      expect(result[1].city).to eq 'Rio de Janeiro'
      expect(result[1].state).to eq 'RJ'

      expect(result[2].cpf).to eq '98765432112'
      expect(result[2].name).to eq 'Roberto Marcos'
      expect(result[2].email).to eq 'roberto@email.com'
      expect(result[2].birthdate).to eq '2000-08-04'
      expect(result[2].address).to eq 'Rua da Praia'
      expect(result[2].city).to eq 'Recife'
      expect(result[2].state).to eq 'PE'
    end

    it 'return empty array when table is empty' do
      result = Patient.all(@conn)

      expect(result.count).to eq 0
      expect(result).to eq []
    end
  end

  context '#find_by' do
    it 'return object that exists in database' do
      Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                       birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                       state: 'SP' }, @conn)
      Patient.create({ cpf: '54621387954', name: 'Juliana Moedas', email: 'juliana@email.com',
                       birthdate: Date.new(1985, 5, 18), address: 'Rua Carvalho', city: 'Rio de Janeiro',
                       state: 'RJ' }, @conn)

      result = Patient.find_by('cpf', '54621387954', @conn)

      expect(result.class).to eq Patient
      expect(result.cpf).to eq '54621387954'
      expect(result.name).to eq 'Juliana Moedas'
      expect(result.email).to eq 'juliana@email.com'
      expect(result.birthdate).to eq '1985-05-18'
      expect(result.address).to eq 'Rua Carvalho'
      expect(result.city).to eq 'Rio de Janeiro'
      expect(result.state).to eq 'RJ'
    end

    it 'return nil when it does not exist in database' do
      Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                       birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                       state: 'SP' }, @conn)
      Patient.create({ cpf: '54621387954', name: 'Juliana Moedas', email: 'juliana@email.com',
                       birthdate: Date.new(1985, 5, 18), address: 'Rua Carvalho', city: 'Rio de Janeiro',
                       state: 'RJ' }, @conn)

      result = Patient.find_by('cpf', '111111111111', @conn)

      expect(result).to be nil
    end
  end

  context '#find_by_id' do
    it 'return object when it exists in database' do
      Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                       birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                       state: 'SP' }, @conn)
      patient = Patient.create({ cpf: '54621387954', name: 'Juliana Moedas', email: 'juliana@email.com',
                                 birthdate: Date.new(1985, 5, 18), address: 'Rua Carvalho', city: 'Rio de Janeiro',
                                 state: 'RJ' }, @conn)

      result = Patient.find_by_id(patient.id, @conn)

      expect(result.class).to eq Patient
      expect(result.cpf).to eq '54621387954'
      expect(result.name).to eq 'Juliana Moedas'
      expect(result.email).to eq 'juliana@email.com'
      expect(result.birthdate).to eq '1985-05-18'
      expect(result.address).to eq 'Rua Carvalho'
      expect(result.city).to eq 'Rio de Janeiro'
      expect(result.state).to eq 'RJ'
    end

    it 'return nil when it does not exist in database' do
      Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                       birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                       state: 'SP' }, @conn)

      result = Patient.find_by_id(99_999, @conn)

      expect(result).to be nil
    end
  end

  context '#create' do
    it 'return object when it is created in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)

      result = @conn.exec('SELECT * FROM patients;').entries[0]

      expect(patient.class).to eq Patient
      expect(result['cpf']).to eq '12345678912'
      expect(result['name']).to eq 'Lucas Vasques'
      expect(result['email']).to eq 'lucas@email.com'
      expect(result['birthdate']).to eq '1995-11-08'
      expect(result['address']).to eq 'Rua Silva e Silva'
      expect(result['city']).to eq 'São Paulo'
      expect(result['state']).to eq 'SP'

      expect(patient.cpf).to eq '12345678912'
      expect(patient.name).to eq 'Lucas Vasques'
      expect(patient.email).to eq 'lucas@email.com'
      expect(patient.birthdate).to eq '1995-11-08'
      expect(patient.address).to eq 'Rua Silva e Silva'
      expect(patient.city).to eq 'São Paulo'
      expect(patient.state).to eq 'SP'
    end
  end

  context '#exams' do
    it 'return array with the instance patient exams' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      other_patient = Patient.create({ cpf: '54621387954', name: 'Juliana Moedas', email: 'juliana@email.com',
                                       birthdate: Date.new(1985, 5, 18), address: 'Rua Carvalho', city: 'Rio Janeiro',
                                       state: 'RJ' }, @conn)

      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)
      Exam.create({ token: 'PGIE13', date: Date.new(2024, 0o1, 18), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)
      Exam.create({ token: 'N213GJ', date: Date.new(2024, 0o2, 0o3), patient_id: other_patient.id,
                    doctor_id: doctor.id },
                  @conn)

      result = patient.exams(@conn)

      expect(result.count).to eq 2
      expect(result[0].token).to eq 'IG4O21'
      expect(result[0].date).to eq '2024-01-12'

      expect(result[1].token).to eq 'PGIE13'
      expect(result[1].date).to eq '2024-01-18'
    end

    it 'return empty array when there are no exams' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(1995, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      no_exams_patient = Patient.create({ cpf: '54621387954', name: 'Juliana Moedas', email: 'juliana@email.com',
                                          birthdate: Date.new(1985, 5, 18), address: 'Rua Carvalho',
                                          city: 'Rio de Janeiro', state: 'RJ' }, @conn)

      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)

      result = no_exams_patient.exams(@conn)

      expect(result.count).to eq 0
      expect(result).to eq []
    end
  end
end
