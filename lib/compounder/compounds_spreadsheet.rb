require 'csv'

module Compounder
  class CompoundsSpreadsheet
    attr_reader :file_path, :csv_klass
    def initialize(file_path: '', csv_klass: CSV)
      @file_path = file_path
      @csv_klass = csv_klass
    end

    def rows
      csv_klass.read(file_path).to_a[1..-1]
    end
  end
end
