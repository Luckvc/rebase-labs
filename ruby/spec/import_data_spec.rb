require 'spec_helper'
require_relative '../import_from_csv'
require_relative '../server'


describe 'Import data from csv' do
  it 'and divide it into classes' do
    test_data = CSV.read('spec/support/test_data.csv', col_sep: ';')
    allow(CSV).to receive(:read).and_return(test_data)
    import_from_csv

    expect(Patient.all(@conn).count).to eq 3
    expect(Exam.all(@conn).count).to eq 3
    expect(Doctor.all(@conn).count).to eq 3
    expect(Test.all(@conn).count).to eq 3
  end
end