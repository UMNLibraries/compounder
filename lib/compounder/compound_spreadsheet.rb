require 'csv'

module Compounder
  class CompoundSpreadsheet
    attr_reader :row, :file_klass, :dir_klass
    def initialize(row: [], file_klass: File, dir_klass: Dir)
      @row = row
      @file_klass = file_klass
      @dir_klass = dir_klass
    end

    def to_csv
      CSV.generate do |csv|
        compound.each do |c|
          csv << c
        end
        fill_down.each do |f|
          csv << f
        end
        csv
      end
    end

    def transcripts_path
      field_value('Transcript Path')
    end

    private

    def compound
      [
        output_header,
        row[2..(row.length)],
      ]
    end

    def output_header
      columns[2..(columns.length)]
    end

    def fill_down
      images.each_with_index.map do |image_name, i|
        [
          page_title(i),
          fill_empty(1..15),
          transcript(image_name),
          fill_empty(1..19),
          dls_identifier(image_name),
          fill_empty(1..6),
          image_name
      ].flatten
      end
    end

    def fill_empty(range)
      range.to_a.map { |foo| '' }
    end

    def dls_identifier(image_name)
      image_name.gsub(/\.tif/, '')
    end

    def page_title(num)
      "Page #{num}"
    end

    def transcript(name)
      file_klass.read(
        file_klass.join(transcripts_path, name.gsub(/\.tif/, '.txt'))
      )
    end

    def images
      @images ||= dir_klass["#{image_path}/*"].sort.map do |path|
        File.basename(path)
      end
    end

    def image_path
      field_value('Image Path')
    end

    def field_value(label)
      row[columns.index(label)]
    end

    def columns
      [
        'Image Path',
        'Transcript Path',
        'TITLE',
        'ALTERNATIVE TITLE',
        'CREATOR',
        'CONTRIBUTOR',
        'PUBLISHER',
        'DESCRIPTION',
        'CAPTION',
        'ADDITIONAL NOTES',
        'DATE OF CREATION',
        'HISTORICAL ERA/PERIOD',
        'ITEM TYPE',
        'ITEM PHYSICAL FORMAT',
        'DIMENTIONS',
        'LOCALLY ASSIGNED SUBJECT HEADINGS',
        'FAST SUBJECT HEADINGS',
        'LANGUAGE',
        'TRANSCRIPTION',
        'TRANSLATION',
        'CITY OR TOWNSHIP',
        'STATE OR PROVINCE',
        'COUNTRY',
        'REGION OR AREA',
        'CONTINENT',
        'PROJECTIONS',
        'SCALE',
        'GEONAMES URI',
        'PARENT COLLECTION NAME',
        'CONTRIBUTING ORGANIZATION',
        'CONTACT INFORMATION',
        'LOCAL RIGHTS STATEMENT',
        'STANDARDIZED RIGHTS STATEMENT',
        'RIGHTS STATEMENT URI',
        'FISCAL SPONSOR',
        'LOCAL IDENTIFIER',
        'BARCODE IDENTIFIER',
        'SYSTEM IDENTIFIER',
        'DLS IDENTIFIER',
        'KALTURA AUDIO IDENTIFIER',
        'KALTURA AUDIO PLAYLIST IDENTIFIER',
        'KALTURA VIDEO IDENTIFIER',
        'KALTURA VIDEO PLAYLIST IDENTIFIER',
        'KALTURA AUDIO/VIDEO PLAYLIST IDENTIFIER',
        'PERSISTENT URL (PURL)',
        'OBJECT FILE NAME'
      ]
    end

  end
end
