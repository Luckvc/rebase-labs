require 'spec_helper'


RSpec.describe DBConnecterService do
  context '#connect' do
    it 'success' do
      conn = DBConnecterService.connect

      expect(conn.host).to eq 'postgres'
    end
  end
end