# app/workers/hard_worker.rb
class ImageWorker
  include Sidekiq::Worker

  def perform(filename, raw_post)
    puts "Starging work with image"
  end
end