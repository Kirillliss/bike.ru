$ ->
  lv_select = "#select_product_offer"

  # делаем чтобы не было выбраноничего
  # $(lv_select + " :selected").each ->
  #   @selected = false

  # Событие выбора характеристики
  $(lv_select).change ->
    $('#select_characteristic_price').html $(lv_select + " :selected").data('price')
    quantity_limit = $(lv_select + " :selected").data('quantity')
    $('#select_characteristic_quantity').html 'На складе: ' + quantity_limit
    $('#select_characteristic_quantity').data('limit', quantity_limit)


  # html = 'На складе: ' + $("#select_characteristic_price :selected").data('quantity')
  # $('#select_characteristic_quantity').html(html)