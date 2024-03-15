# frozen_string_literal: true

require 'spec_helper'
require 'require_all'
require_all 'models'

RSpec.describe Exam, type: :model do
  context '#all' do
    it 'return array with every instance in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)
      Exam.create({ token: 'PGIE13', date: Date.new(2024, 0o1, 18), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)
      Exam.create({ token: 'N213GJ', date: Date.new(2024, 0o2, 0o3), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)

      result = Exam.all(@conn)

      expect(result.count).to eq 3
      expect(result[0].token).to eq 'IG21'
      expect(result[0].date).to eq '2024-01-12'
      expect(result[0].patient_id).to eq patient.id
      expect(result[0].doctor_id).to eq doctor.id

      expect(result[1].token).to eq 'PGIE13'
      expect(result[1].date).to eq '2024-01-18'
      expect(result[1].patient_id).to eq patient.id
      expect(result[1].doctor_id).to eq doctor.id

      expect(result[2].token).to eq 'N213GJ'
      expect(result[2].date).to eq '2024-02-03'
      expect(result[2].patient_id).to eq patient.id
      expect(result[2].doctor_id).to eq doctor.id
    end

    it 'return empty array when table is empty' do
      result = Exam.all(@conn)

      expect(result.count).to eq 0
      expect(result).to eq []
    end
  end

  context '#find_by' do
    it 'return object that exists in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)
      Exam.create({ token: 'PGIE13', date: Date.new(2024, 0o1, 18), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)

      result = Exam.find_by('token', 'PGIE13', @conn)

      expect(result.class).to eq Exam
      expect(result.token).to eq 'PGIE13'
      expect(result.date).to eq '2024-01-18'
      expect(result.patient_id).to eq patient.id
      expect(result.doctor_id).to eq doctor.id
    end

    it 'return nil when it does not exist in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)

      result = Exam.find_by('token', '99999', @conn)

      expect(result).to be nil
    end
  end

  context '#find_by_id' do
    it 'return object when it exists in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      exam = Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                         @conn)

      result = Exam.find_by_id(exam.id, @conn)

      expect(result.class).to eq Exam
      expect(result.token).to eq 'IG21'
      expect(result.date).to eq '2024-01-12'
      expect(result.patient_id).to eq patient.id
      expect(result.doctor_id).to eq doctor.id
    end

    it 'return nil when it does not exist in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                  @conn)

      result = Exam.find_by_id(99_999, @conn)

      expect(result).to be nil
    end
  end

  context '#create' do
    it 'return object when it is created in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)

      exam = Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                         @conn)

      result = @conn.exec('SELECT * FROM exams;').entries[0]

      expect(patient.class).to eq Patient
      expect(result['token']).to eq 'IG21'
      expect(result['date']).to eq '2024-01-12'
      expect(result['patient_id']).to eq patient.id
      expect(result['doctor_id']).to eq doctor.id

      expect(exam.token).to eq 'IG21'
      expect(exam.date).to eq '2024-01-12'
      expect(exam.patient_id).to eq patient.id
      expect(exam.doctor_id).to eq doctor.id
    end
  end

  context '#create_test' do
    it 'creates a test associated with a exam' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                         @conn)

      test_exam = exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)
      result = @conn.exec('SELECT * FROM tests;').entries[0]

      expect(test_exam.class).to eq Test
      expect(result['type']).to eq 'hemácias'
      expect(result['limits']).to eq '45-52'
      expect(result['result']).to eq '97'
      expect(result['exam_id']).to eq exam.id

      expect(test_exam.type).to eq 'hemácias'
      expect(test_exam.limits).to eq '45-52'
      expect(test_exam.result).to eq '97'
      expect(test_exam.exam_id).to eq exam.id
    end
  end

  context '#tests' do
    it 'return array with the tests associated with a exam' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                         @conn)

      exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)
      exam.create_test({ type: 'leucócitos', limits: '9-61', result: '89' }, @conn)

      result = exam.tests(@conn)

      expect(result.count).to eq 2
      expect(result[0].type).to eq 'hemácias'
      expect(result[0].limits).to eq '45-52'
      expect(result[0].result).to eq '97'
      expect(result[0].exam_id).to eq exam.id

      expect(result[1].type).to eq 'leucócitos'
      expect(result[1].limits).to eq '9-61'
      expect(result[1].result).to eq '89'
      expect(result[1].exam_id).to eq exam.id
    end

    it 'return empty array when there are no tests' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG21', date: Date.new(2024, 0o1, 12), patient_id: patient.id, doctor_id: doctor.id },
                         @conn)
      no_test_exam = Exam.create(
        { token: 'PGIE13', date: Date.new(2024, 0o1, 18), patient_id: patient.id, doctor_id: doctor.id }, @conn
      )

      exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)

      result = no_test_exam.tests(@conn)

      expect(result.count).to eq 0
      expect(result).to eq []
    end
  end
end
