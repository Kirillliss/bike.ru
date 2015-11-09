class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  mount_uploader :image, ImageUploader
  # validates :image, presence: true
  # process_in_background :image

  def self.process_imported(filename, raw_post)    
    i = Image.find_by(one_ass_path: filename)
    # import_files/9b/9bcf14d07ae011e0a9db7071bcdbea6f_c5472b02c17c4c44a718e1021c93373b.jpg
    ext = filename.split('.').last
    temp_file = Tempfile.new("image.#{ext}", :encoding => 'ascii-8bit')
    # temp_file = Tempfile.new("image.#{ext}", :encoding => 'utf-8')
    temp_file.write(raw_post)
    temp_file.close
    i.image = temp_file
    i.save
    temp_file.unlink
    puts i.inspect  
  end
end
