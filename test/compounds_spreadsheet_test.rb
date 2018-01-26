require 'test_helper'
require 'csv'
module Compounder
  describe CompoundsSpreadsheet do
    let(:csv_klass) { Minitest::Mock.new }
    it 'converts a row' do
      file_path = 'foo/bar/compounds.csv'
      compounds_csv = CSV.read(File.join(File.dirname(__FILE__), '/fixtures/compounds.csv'))
      csv_klass.expect :read, compounds_csv, ["foo/bar/compounds.csv"]
      valid_rows = compounds_csv[1..-1]
      spreadsheet = CompoundsSpreadsheet.new(file_path: file_path, csv_klass: csv_klass)
      spreadsheet.rows.must_equal(valid_rows)
    end
  end
end