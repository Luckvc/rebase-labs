require 'spec_helper'
require 'require_all'
require_all 'models'

RSpec.describe Doctor, type: :model do
  context '#all' do
    it 'return array with every instance in database' do
      Doctor.create({crm: '123456', crm_state: 'SP', name: 'Lucas Vasques', email: 'lucas@email.com'}, @conn)
      Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)
      Doctor.create({crm: '248624', crm_state: 'MA', name: 'Maria Luisa Gonçalvez', email: 'mlgon@email.com'}, @conn)

      result = Doctor.all(@conn)

      expect(result.count).to eq 3
      expect(result[0].crm).to eq '123456'
      expect(result[0].crm_state).to eq 'SP'
      expect(result[0].name).to eq 'Lucas Vasques'
      expect(result[0].email).to eq 'lucas@email.com'

      expect(result[1].crm).to eq '654321'
      expect(result[1].crm_state).to eq 'CE'
      expect(result[1].name).to eq 'Leonardo Silva'
      expect(result[1].email).to eq 'leo@email.com'

      expect(result[2].crm).to eq '248624'
      expect(result[2].crm_state).to eq 'MA'
      expect(result[2].name).to eq 'Maria Luisa Gonçalvez'
      expect(result[2].email).to eq 'mlgon@email.com'
    end

    it 'return empty array when table is empty' do
      result = Doctor.all(@conn)

      expect(result.count).to eq 0
      expect(result).to eq []
    end
  end

  context '#find_by' do
    it 'return object that exists in database' do
      Doctor.create({crm: '123456', crm_state: 'SP', name: 'Lucas Vasques', email: 'lucas@email.com'}, @conn)
      Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)

      result = Doctor.find_by('name', 'Lucas Vasques', @conn)

      expect(result.class).to eq Doctor
      expect(result.crm).to eq '123456'
      expect(result.crm_state).to eq 'SP'
      expect(result.name).to eq 'Lucas Vasques'
      expect(result.email).to eq 'lucas@email.com'
    end

    it 'return nil when it does not exist in database' do
      Doctor.create({crm: '123456', crm_state: 'SP', name: 'Lucas Vasques', email: 'lucas@email.com'}, @conn)
      Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)

      result = Doctor.find_by('crm', '99999', @conn)

      expect(result).to be nil
    end
  end

  context '#find_by_id' do
    it 'return object when it exists in database' do
      Doctor.create({crm: '123456', crm_state: 'SP', name: 'Lucas Vasques', email: 'lucas@email.com'}, @conn)
      doctor = Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)

      result = Doctor.find_by_id(doctor.id, @conn)

      expect(result.class).to eq Doctor
      expect(result.crm).to eq '654321'
      expect(result.crm_state).to eq 'CE'
      expect(result.name).to eq 'Leonardo Silva'
      expect(result.email).to eq 'leo@email.com'
    end

    it 'return nil when it does not exist in database' do
      Doctor.create({crm: '123456', crm_state: 'SP', name: 'Lucas Vasques', email: 'lucas@email.com'}, @conn)

      result = Doctor.find_by_id(99999, @conn)

      expect(result).to be nil
    end
  end

  context '#find_by_crm_and_state' do
    it 'return object when it exists in database' do
      Doctor.create({crm: '123456', crm_state: 'SP', name: 'Lucas Vasques', email: 'lucas@email.com'}, @conn)
      Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)

      result = Doctor.find_by_crm_and_state('654321', 'CE', @conn)

      expect(result.class).to eq Doctor
      expect(result.crm).to eq '654321'
      expect(result.crm_state).to eq 'CE'
      expect(result.name).to eq 'Leonardo Silva'
      expect(result.email).to eq 'leo@email.com'
    end

    it 'return nil when object does not exist' do
      Doctor.create({crm: '123456', crm_state: 'SP', name: 'Lucas Vasques', email: 'lucas@email.com'}, @conn)
      Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)

      result = Doctor.find_by_crm_and_state('93746', 'RJ', @conn)
      
      expect(result).to be nil
    end
  end

  context '#create' do
    it 'return object when it is created in database' do
      doctor = Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)

      result = @conn.exec("SELECT * FROM doctors;").entries[0]

      expect(doctor.class).to eq Doctor
      expect(result['crm']).to eq '654321'
      expect(result['crm_state']).to eq 'CE'
      expect(result['name']).to eq 'Leonardo Silva'
      expect(result['email']).to eq 'leo@email.com'

      expect(doctor.crm).to eq '654321'
      expect(doctor.crm_state).to eq 'CE'
      expect(doctor.name).to eq 'Leonardo Silva'
      expect(doctor.email).to eq 'leo@email.com'
    end
  end

  context '#exams' do
    it 'return array with the instance doctor exams' do
      patient = Patient.create({cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com', birthdate: Date.new(2000, 11, 8),
                      address: 'Rua Silva e Silva', city: 'São Paulo', state:'SP'}, @conn)

      doctor = Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)
      other_doctor = Doctor.create({crm: '248624', crm_state: 'MA', name: 'Maria Luisa Gonçalvez', email: 'mlgon@email.com'}, @conn)

      Exam.create({token: 'IG4O21', date: Date.new(2024, 01, 12), patient_id: patient.id, doctor_id: doctor.id}, @conn)
      Exam.create({token: 'PGIE13', date: Date.new(2024, 01, 18), patient_id: patient.id, doctor_id: doctor.id}, @conn)
      Exam.create({token: 'N213GJ', date: Date.new(2024, 02, 03), patient_id: patient.id, doctor_id: other_doctor.id}, @conn)

      result = doctor.exams(@conn)

      expect(result.count).to eq 2
      expect(result[0].token).to eq 'IG4O21'
      expect(result[0].date).to eq '2024-01-12'

      expect(result[1].token).to eq 'PGIE13'
      expect(result[1].date).to eq '2024-01-18'
    end

    it 'return empty array when there are no exams' do
      patient = Patient.create({cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com', birthdate: Date.new(2000, 11, 8),
                      address: 'Rua Silva e Silva', city: 'São Paulo', state:'SP'}, @conn)

      doctor = Doctor.create({crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com'}, @conn)
      no_exams_doctor = Doctor.create({crm: '248624', crm_state: 'MA', name: 'Maria Luisa Gonçalvez', email: 'mlgon@email.com'}, @conn)

      Exam.create({token: 'IG4O21', date: Date.new(2024, 01, 12), patient_id: patient.id, doctor_id: doctor.id}, @conn)

      result = no_exams_doctor.exams(@conn)

      expect(result.count).to eq 0
      expect(result).to eq []
    end
  end
end