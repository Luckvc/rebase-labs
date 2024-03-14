# frozen_string_literal: true

require 'spec_helper'
require_relative '../../jobs/import_job'

RSpec.describe ImportJob do
  context '#perform' do
    it 'data is imported' do
      test_data = CSV.read('spec/support/test_data.csv', col_sep: ';')

      ImportJob.perform_sync(test_data)

      expect(Patient.all(@conn).count).to eq 3
      expect(Exam.all(@conn).count).to eq 3
      expect(Doctor.all(@conn).count).to eq 3
      expect(Test.all(@conn).count).to eq 3
    end

    it 'data is not imported' do
      wrong_data = CSV.read('spec/support/wrong_test_data.csv', col_sep: ';')

      ImportJob.perform_sync(wrong_data)

      expect(Patient.all(@conn).count).to eq 0
      expect(Exam.all(@conn).count).to eq 0
      expect(Doctor.all(@conn).count).to eq 0
      expect(Test.all(@conn).count).to eq 0
    end
  end
end
