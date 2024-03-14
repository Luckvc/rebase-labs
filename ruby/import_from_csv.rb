require_relative 'services/data_importer_service'

begin
  csv = CSV.read('data.csv', col_sep:';') 
  DataImporterService.import_from_csv(csv)
rescue PG::Error
  puts 'Erro: Dados não compatíveis'
end