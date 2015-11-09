class ImportImageWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: true

  def perform(image_id, file_path)
    begin
      image = Image.find(image_id)
      temp_file = File.open(file_path)
      image.image = temp_file
      image.save!
      Rails.logger.info("Image##{image.id} file update DONE")
    rescue
      Rails.logger.info("Image##{image.id} file update FAILED")
    ensure
      File.delete(file_path)
    end
  end
end
