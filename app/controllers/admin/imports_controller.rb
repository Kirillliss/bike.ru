#require 'import_from_excel'

require 'csv'
require 'open-uri'

class ImportFromExcel

  def rows_from_url(url, with_headers = false)
    csv_data = open(url, "r:UTF-8")
    CSV.parse(csv_data.read, headers: with_headers) # :encoding => 'windows-1251:utf-8'
  end

  def rows_from_path(path, with_headers = false)
    CSV.foreach(path, headers: with_headers) # :encoding => 'windows-1251:utf-8'
  end

  #############################################################
  # Информация:
  #############################################################
  # двумерный массив с содержимым всего файла
  # Пример:
  # [
  #   ["title", "producer_price"],
  #   ["Шиповки спринт ЭЛИТ (б у)", "7369"],
  #   ["Шиповки СПРИНТ КЛАССИКА(новяк)", "8219"]
  # ]
  #############################################################
  def rows(with_headers = false)
    @file[0..3] == 'http' ? rows_from_url(@file, with_headers) : rows_from_url(@file, with_headers)
  end

  def testing
    tmp_path = "/home/pavel/RailsProjects/newskibike/tmp/uploads/import/file_xls/7/file_for_upload.csv"
    tmp_url = "https://skibikeru.s3.amazonaws.com/uploads/import/file_xls/7/file_for_upload.csv"
    rows_from_path(tmp_path, true).each {|r| p r }
    rows_from_url(tmp_url, true).each {|r| p r }
    rows_from_path(tmp_path).each {|r| p r }
    rows_from_url(tmp_url).each {|r| p r }
  end

  def initialize(file)
    @file = file
    # testing()
  end

  # Получение массива заголовков столбцов
  def header_row
    rows[0]
  end

  # ratio ("поле в файле" => "поле в бд")
  # {"Название"=>"title", "Цена производителя"=>"producer_price", ...}
  def get_params(ratio = {})
    result = []
    rows(true).each do |row|
      params = {}
      row.each { |key, value| params[ratio[key].to_sym] = value }
      result << params
    end
    result
  end

end


class Admin::ImportsController < Admin::BaseController
  before_action :set_import, only: [:show, :proccess, :edit, :update, :destroy]
  before_action :set_all_imports, only: [:index, :show]

  def initialize
    @curr_url = "https://skibikeru.s3.amazonaws.com/uploads/import/file_xls/6/file_for_upload.csv"
    super
  end

  # GET /admin/imports
  def index
    @import = Import.new
  end

  # GET /admin/imports/1
  def show
    # @file = { headers: ImportFromExcel.new(@import.file_xls.file_from_storage).header_row }
  end

  # GET /admin/imports/new
  def new
    @import = Import.new
  end

  # GET /admin/imports/1/edit
  def edit
  end

  def proccess
    @import.import_csv_lines.each do |line|
      product = @import.stock.products.where(article: line[:article]).first_or_initialize
      product[:title] = line[:title]
      product[:barcode] = line[:barcode]
      product.save
    end
    @import[:proccessed_at] = Time.now
    if @import.save
      redirect_to admin_import_path(@import)
    else
      render :show
    end
  end

  # POST /admin/imports
  def create
    @import = Import.new(import_params)
    if @import.save
      puts "========================"
      puts "@import.file_xls.file_from_storage: #{@import.file_xls.file_from_storage}"
      puts "rows: #{ImportFromExcel.new(@import.file_xls.file_from_storage).rows}"
      puts "========================"
      ImportFromExcel.new(@import.file_xls.file_from_storage).rows.each_with_index do |row, index|
        next if index == 0
        import_csv_line = @import.import_csv_lines.new
        import_csv_line[:article] = row[0]
        import_csv_line[:title] = row[1]
        import_csv_line[:size] = row[2]
        import_csv_line[:price] = row[3]
        import_csv_line[:stock] = row[4]
        import_csv_line[:barcode] = row[5]
        import_csv_line.save
      end
      redirect_to admin_import_path(@import), notice: 'Import was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/imports/1
  def update
    if @import.update(import_params)
      redirect_to admin_import_path(@import), notice: 'Import was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/imports/1
  def destroy
    @import.destroy
    redirect_to admin_imports_url, notice: 'Import was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    def set_all_imports
      @imports = Import.all
    end

    # def import_file_path_or_url
    #   Rails.env.Production? ? @import.file_xls.url : @import.file_xls.path
    # end

    # Only allow a trusted parameter "white list" through.
    def import_params
      params.require(:import).permit(:file_xls, :stock_id)
    end

end
