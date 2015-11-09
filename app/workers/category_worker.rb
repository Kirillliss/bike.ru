# app/workers/hard_worker.rb
require 'nokogiri'
class CategoryWorker
  include Sidekiq::Worker

  def perform(group)
    Product.extract_group(group, 1)
  end
end