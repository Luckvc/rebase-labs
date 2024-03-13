require 'sidekiq'
require_relative '../data_importer'

class ImportJob
  include Sidekiq::Job

  def perform(csv)
    DataImporter.import_from_csv(csv)
  rescue PG::Error
    puts 'Dados Incompatíveis'
  end
end