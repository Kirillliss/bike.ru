class Import < ActiveRecord::Base

  has_many :products, through: :stock
  belongs_to :stock

  has_many :import_csv_lines, dependent: :destroy

  mount_uploader :file_xls, CsvUploader

end
