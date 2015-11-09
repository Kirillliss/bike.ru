# app/workers/hard_worker.rb
require 'nokogiri'
class PropertyWorker
  include Sidekiq::Worker

  def perform(property)
    Product.extract_property_and_values(property)
  end
end