require_relative 'data_importer'

begin
  csv = CSV.read('data.csv', col_sep:';') 
  DataImporter.import_from_csv(csv)
rescue PG::Error
  puts 'Erro: Dados não compatíveis'
end