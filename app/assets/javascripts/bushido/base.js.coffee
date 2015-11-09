$ ->

  $('button.close').click (e) ->
    e.preventDefault()
    hide_target = $(this).data('target')
    $(hide_target).fadeOut('slow').remove()
    # alert hide_target

  $(".owl-carousel").owlCarousel
    navigation : false # Show next and prev buttons
    slideSpeed : 600
    paginationSpeed : 400
    singleItem: true
    pagination: true
    autoPlay: true
    autoHeight: false

    responsive: true
    responsiveBaseWidth: window

    # "singleItem:true" is a shortcut for:
    # items : 1,
    # itemsDesktop : false,
    # itemsDesktopSmall : false,
    # itemsTablet: false,
    # itemsMobile : false

  $(".small_image").click ->
    src = $(this).data('src')
    $('#big_image').attr('src', src)




  #Catalog Filters
  # ******************************************

  #Price Slider Range
  $minVal = parseInt($("#minVal").attr("data-min-val"))
  $maxVal = parseInt($("#maxVal").attr("data-max-val"))
  $startMin = parseInt($("#minVal").val())
  $startMax = parseInt($("#maxVal").val())
  if $("#price-range").length > 0
    $("#price-range").noUiSlider
      range:
        min: $minVal
        max: $maxVal

      start: [
        $startMin
        $startMax
      ]
      connect: true
      serialization:
        lower: [$.Link(
          target: $("#minVal")
          format:
            decimals: 0
        )]
        upper: [$.Link(
          target: $("#maxVal")
          format:
            decimals: 0
        )]


  #Clear price filters
  $("#clearPrice").click ->
    $("#price-range").val [
      $startMin
      $startMax
    ],
      set: true

    return


  #Clear Checkbox filters
  $(".clearChecks").click ->
    $(this).parent().find(".icheckbox").removeClass "checked"
    return