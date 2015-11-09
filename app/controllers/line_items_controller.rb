class LineItemsController < BaseController
  before_action :set_cart, only: [:create, :add_to_cart, :update]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  def add_to_cart
    create
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    if params[:product_id]
      product = Product.find(params[:product_id])
      @line_item = @cart.add_product(product.id)
    elsif params[:special_offer_id]
      special_offer = SpecialOffer.find(params[:special_offer_id])
      @line_item = @cart.add_special_offer(special_offer.id)
    end

    @line_item.offer_limit = params[:offer_limit]

    # # Добавляем характеристики
    # if params[:characteristic_name_ids]
    #   params[:characteristic_name_ids].each do |key, name_id|
    #     line_item_characteristic = @line_item.line_item_characteristics.find_by(characteristic_name_id: name_id)
    #     line_item_characteristic ||= @line_item.line_item_characteristics.new
    #     line_item_characteristic[:characteristic_name_id] = name_id
    #     line_item_characteristic[:characteristic_value_id] = params[:characteristic_value_ids][name_id]
    #     line_item_characteristic.save
    #   end
    # end

    if params[:offer]
      params[:offer].split(',').each_with_index do |value, index|
        case index
          when 0
            characteristics_from_offer = ""
            ProductOffer.find(value.to_i).offer_characteristics.each do |offer_characteristic|
              characteristics_from_offer += "#{offer_characteristic.title}: #{offer_characteristic.value}. "
            end
            @line_item.characteristics_from_offer = characteristics_from_offer
          when 1
            price_from_offer = OfferPrice.find(value.to_i)
            @line_item.price_from_offer = "#{price_from_offer.price}/#{price_from_offer.coefficient}/#{price_from_offer.unit}"
        end
      end
    end

    if params[:quantity]
      @line_item.quantity = params[:quantity]
    end

    respond_to do |format|
      if @line_item.save
        format.html do
          if @line_item.product
            redirect_to [@line_item.product.category, @line_item.product], notice: 'Товар добавлен в корзину'
          else
            redirect_to root_path
          end
        end
        format.js { @current_item = @line_item }
        format.json { render action: 'show',
          status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
          status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @line_item }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end


  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    p @line_item.inspect
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :quantity, :special_offer_id)
    end
end
