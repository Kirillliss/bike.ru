# app/workers/hard_worker.rb
require 'nokogiri'
class ProductWorker
  include Sidekiq::Worker

  def perform(product)
    Product.extract_product(product)
  end
end