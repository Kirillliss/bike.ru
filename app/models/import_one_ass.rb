class ImportOneAss < ActiveRecord::Base
  mount_uploader :offers, CsvUploader
  mount_uploader :import, CsvUploader

  STR = '================================================='
  # after_save :proccess_import_xml, :proccess_offers_xml

  attr_accessor :import_xml_raw, :offers_xml_raw

  def attach_xml!(dirty_xml, name)
    if dirty_xml && dirty_xml.present? && name && name.present?
      if name == 'import.xml'
        @import_xml_raw = dirty_xml
        self.import_xml = Base64.encode64(Zlib::Deflate.deflate(dirty_xml))
        if save
          puts "OK import_xml. Waiting offers."
        end
      elsif name == 'offers.xml'
        @offers_xml_raw = dirty_xml
        self.offers_xml = Base64.encode64(Zlib::Deflate.deflate(dirty_xml))
        if save
          puts "OK offers_xml. Starting process!"
          ImportWorker.perform_async(id)
        end
      end
    else
      false
    end
  end

  def proccess_import_xml
    begin
      processor = OneAssProcessor.new
      if import_xml.present?
        processor.xml = Zlib::Inflate.inflate(Base64.decode64(self.import_xml)).force_encoding('UTF-8')
        processor.process_categories!
        processor.process_properties_and_values!
        processor.process_products!
      end
    rescue Exception => e
      puts "e: #{e.inspect}"
    end
  end

  def proccess_offers_xml
    processor = OneAssProcessor.new
    if offers_xml.present?
      processor.xml = Zlib::Inflate.inflate(Base64.decode64(self.offers_xml)).force_encoding('UTF-8')
      processor.process_offers!
    end
  end

  private
    def validate_xml
      if @import_xml_raw.present?
        doc = Nokogiri::XML(import_xml)
        if doc.xpath('//Товары').empty?
          errors.add(:import_xml, 'Невалидный import.xml')
        end
      end
      if @offers_xml_raw.present?
        doc = Nokogiri::XML(offers_xml)
        if doc.xpath('//Предложения').empty?
          errors.add(:offers_xml, 'Невалидный offers.xml')
        end
      end
    end

end
