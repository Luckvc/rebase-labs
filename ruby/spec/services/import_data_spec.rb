# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataImporterService do
  context '#import_from_csv' do
    it 'success' do
      test_data = CSV.read('spec/support/test_data.csv', col_sep: ';')

      DataImporterService.import_from_csv(test_data)

      expect(Patient.all(@conn).count).to eq 3
      expect(Exam.all(@conn).count).to eq 3
      expect(Doctor.all(@conn).count).to eq 3
      expect(Test.all(@conn).count).to eq 3
    end
  end
end
