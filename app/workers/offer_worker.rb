# app/workers/hard_worker.rb
require 'nokogiri'
class OfferWorker
  include Sidekiq::Worker

  def perform(offer)
    Product.extract_offer(offer)
  end
end