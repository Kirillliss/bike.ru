# app/workers/hard_worker.rb
require 'nokogiri'
class ImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = ImportOneAss.find(import_id)
    import.proccess_import_xml
    puts 'Done process import!'
    import.proccess_offers_xml
    puts 'Done process offers!'
  end
end