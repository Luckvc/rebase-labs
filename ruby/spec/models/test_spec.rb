# frozen_string_literal: true

require 'spec_helper'
require 'require_all'
require_all 'models'

RSpec.describe Test, type: :model do
  context '#all' do
    it 'return array with every instance in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id,
                           doctor_id: doctor.id },
                         @conn)

      exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)
      exam.create_test({ type: 'leucócitos', limits: '9-61', result: '89' }, @conn)
      exam.create_test({ type: 'hdl', limits: '19-75', result: '0' }, @conn)

      result = Test.all(@conn)

      expect(result.count).to eq 3
      expect(result[0].type).to eq 'hemácias'
      expect(result[0].limits).to eq '45-52'
      expect(result[0].result).to eq '97'
      expect(result[0].exam_id).to eq exam.id

      expect(result[1].type).to eq 'leucócitos'
      expect(result[1].limits).to eq '9-61'
      expect(result[1].result).to eq '89'
      expect(result[1].exam_id).to eq exam.id

      expect(result[2].type).to eq 'hdl'
      expect(result[2].limits).to eq '19-75'
      expect(result[2].result).to eq '0'
      expect(result[2].exam_id).to eq exam.id
    end

    it 'return empty array when table is empty' do
      result = Test.all(@conn)

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
      exam = Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id,
                           doctor_id: doctor.id },
                         @conn)
      exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)
      exam.create_test({ type: 'leucócitos', limits: '9-61', result: '89' }, @conn)

      result = Test.find_by('type', 'hemácias', @conn)

      expect(result.class).to eq Test
      expect(result.type).to eq 'hemácias'
      expect(result.limits).to eq '45-52'
      expect(result.result).to eq '97'
      expect(result.exam_id).to eq exam.id
    end

    it 'return nil when it does not exist in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id,
                           doctor_id: doctor.id },
                         @conn)
      exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)

      result = Test.find_by('type', '999999', @conn)

      expect(result).to be nil
    end
  end

  context '#find_by_id' do
    it 'return object when it exists in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id,
                           doctor_id: doctor.id },
                         @conn)
      test_ = exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)

      result = Test.find_by_id(test_.id, @conn)

      expect(result.class).to eq Test
      expect(result.type).to eq 'hemácias'
      expect(result.limits).to eq '45-52'
      expect(result.result).to eq '97'
      expect(result.exam_id).to eq exam.id
    end

    it 'return nil when it does not exist in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id,
                           doctor_id: doctor.id },
                         @conn)
      exam.create_test({ type: 'hemácias', limits: '45-52', result: '97' }, @conn)

      result = Test.find_by_id(99_999, @conn)

      expect(result).to be nil
    end
  end

  context '#create' do
    it 'return object when it is created in database' do
      patient = Patient.create({ cpf: '12345678912', name: 'Lucas Vasques', email: 'lucas@email.com',
                                 birthdate: Date.new(2000, 11, 8), address: 'Rua Silva e Silva', city: 'São Paulo',
                                 state: 'SP' }, @conn)
      doctor = Doctor.create({ crm: '654321', crm_state: 'CE', name: 'Leonardo Silva', email: 'leo@email.com' }, @conn)
      exam = Exam.create({ token: 'IG4O21', date: Date.new(2024, 0o1, 12), patient_id: patient.id,
                           doctor_id: doctor.id },
                         @conn)

      test_ = Test.create({ type: 'hemácias', limits: '45-52', result: '97', exam_id: exam.id }, @conn)

      result = @conn.exec('SELECT * FROM tests;').entries[0]

      expect(patient.class).to eq Patient
      expect(result['type']).to eq 'hemácias'
      expect(result['limits']).to eq '45-52'
      expect(result['result']).to eq '97'
      expect(result['exam_id']).to eq exam.id

      expect(test_.type).to eq 'hemácias'
      expect(test_.limits).to eq '45-52'
      expect(test_.result).to eq '97'
      expect(test_.exam_id).to eq exam.id
    end
  end
end
