require 'test_helper'
require 'csv'
module Compounder
  describe CompoundSpreadsheet do
    let(:file_klass) { Minitest::Mock.new }
    let(:dir_klass) { Minitest::Mock.new }
    it 'converts a row' do
      dir_klass.expect :[], ['bausong-001.tif', 'bausong-002.tif'], ["foo/bar/images/bausong/*"]
      file_klass.expect :join, 'foo/bar/transcripts/bausong-001.tif', ["foo/bar/transcripts/bausong", "bausong-001.txt"]
      file_klass.expect :join, 'foo/bar/transcripts/bausong-002.tif', ["foo/bar/transcripts/bausong", "bausong-002.txt"]
      file_klass.expect :read, 'transcript numero uno with bad characters ������', ['foo/bar/transcripts/bausong-001.tif']
      file_klass.expect :read, 'transcript numero dos', ['foo/bar/transcripts/bausong-002.tif']
      file_path = File.join(File.dirname(__FILE__), '/fixtures/compounds.csv')
      valid_csv = File.read(File.join(File.dirname(__FILE__), '/fixtures/compound.csv')).encode('UTF-8',
        'binary',
        invalid: :replace,
        undef: :replace,
        replace: '')
      compounds =  CSV.read(file_path)[1..-1]
      spreadsheet = CompoundSpreadsheet.new(row: compounds.first,
                                    file_klass: file_klass,
                                    dir_klass: dir_klass)
      csv = spreadsheet.to_csv
      csv.must_equal(valid_csv)
    end
  end
end