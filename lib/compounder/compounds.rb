require 'csv'

module Compounder
  class Compounds
    attr_reader :compounds_dir,
                :compounds_spreadsheet,
                :compound_spreadsheet
    def initialize(compounds_dir: '',
                   compounds_spreadsheet: CompoundsSpreadsheet,
                   compound_spreadsheet: CompoundSpreadsheet)
      @compounds_dir = compounds_dir
      @compounds_spreadsheet = compounds_spreadsheet
      @compound_spreadsheet = compound_spreadsheet
    end

    def collections
      unless compounds_dir_exists?
        raise "Compound Collections Directory '#{compounds_dir}' does not exist"
      end
      Dir["#{compounds_dir}/*"].map do |collection_path|
        compounds_spreadsheet.new(file_path: collection_path).rows
      end
    end

    def compounds_dir_exists?
      File.directory?(compounds_dir)
    end

    def transformed
      collections.map do |collection|
        collection.map { |row| compound_spreadsheet.new(row: row).to_csv }
      end.flatten
    end

    def output
      csv_klass.read(file_path).to_a[1..-1]
    end

  end
end
