# frozen_string_literal: true

require 'sidekiq'
require_relative '../services/data_importer_service'

class ImportJob
  include Sidekiq::Job

  def perform(csv)
    DataImporterService.import_from_csv(csv)
  rescue PG::Error
    'Dados Incompatíveis'
  end
end
