require_relative 'data_importer'

csv = CSV.read('data.csv', col_sep:';') 
DataImporter.import_from_csv(csv)