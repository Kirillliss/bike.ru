$ ->
  #Global Variables
  # ******************************************
  $searchBtn = $(".search-btn")
  $searchForm = $(".search-form")
  $closeSearch = $(".close-search")
  $subscrForm = $(".subscr-form")
  $nextField = $(".subscr-next")
  $loginBtn = $(".login-btn")
  $loginForm = $(".modal .login-form")
  $loginForm2 = $(".checkout .login-form")
  $loginForm3 = $(".log-reg .login-form")
  $regForm = $(".registr-form")
  $qcForm = $(".quick-contact")
  $contForm = $(".contact-form")
  $checkoutForm = $("#checkout-form")
  $cartTotal1 = $(".cart-dropdown .total")
  $header = $("header")
  $headerOffsetTop = $header.data("offset-top")
  $headerStuck = $header.data("stuck")
  $menuToggle = $(".menu-toggle")
  $menu = $(".menu")
  $submenuToggle = $(".menu .has-submenu > a > i")
  $submenu = $(".menu .submenu")
  $featureTab = $(".feature-tabs .tab")
  $featureTabPane = $(".feature-tabs .tabs-pane")
  $brandCarousel = $(".brand-carousel .inner")
  $shareBtn1 = $(".tile .share-btn i")
  $offersTabs = $(".offer-tabs .tab-navs a")
  $offersTabsCarousel = $(".offer-tabs .tab-navs")
  $sortToggle = $(".sorting a")
  $activePage = $(".pagination li.active a")
  $subcatToggle = $(".categories.ss > a")
  $filterToggle = $(".filter-toggle")
  $scrollTopBtn = $("#scrollTop-btn")
  $qcfBtn = $("#qcf-btn")
  $addToCartBtn = $("#addItemToCart")
  $addedToCartMessage = $(".cart-message")
  $promoLabels = $(".promo-labels div")
  $panelToggle = $(".panel-toggle")
  $accordionToggle = $(".accordion .panel-heading a")

  #Search Form Toggle
  # ******************************************
  $searchBtn.click ->
    $searchForm.removeClass("closed").addClass "open"
    return

  $closeSearch.click ->
    $searchForm.removeClass("open").addClass "closed"
    return

  $(".page-content, .subscr-widget, footer").click ->
    $searchForm.removeClass("open").addClass "closed"
    return


  #Login Forms
  # ******************************************
  $loginForm.validate()
  $loginForm2.validate()
  $loginForm3.validate()
  $("#log-password").focus ->
    $(this).attr "type", "password"
    return


  #Quick Contact Form Validation
  # ******************************************
  $qcForm.validate()

  #Contact Form Validation
  # ******************************************
  $contForm.validate()

  #Registration Form Validation
  # ******************************************
  $regForm.validate()

  #Checkout Form Validation
  # ******************************************
  $checkoutForm.validate rules:
    co_postcode:
      required: true
      number: true

    co_phone:
      required: true
      number: true


  #Adding Placeholder Support in Older Browsers
  # ***********************************************
  $("input, textarea").placeholder()

  #Shopping Cart Dropdown
  # ******************************************

  #Deleting Items
  $(document).on "click", ".cart-dropdown .delete", ->
    $target = $(this).parent().parent()
    $positions = $(".cart-dropdown .item")
    $positionQty = parseInt($(".cart-btn a span").text())
    $target.hide 300, ->
      $.when($target.remove()).then ->
        $positionQty = $positionQty - 1
        $(".cart-btn a span").text $positionQty
        $(".cart-dropdown .body").html "<h3>Cart is empty!</h3>" if $positions.length is 1
        return

      return

    return


  #Shopping Cart Page
  # ******************************************

  #Deleting Items
  $(document).on "click", ".shopping-cart .delete i", ->
    $target = $(this).parent().parent()
    $positions = $(".shopping-cart .item")
    $target.hide 300, ->
      $.when($target.remove()).then ->
        if $positions.length is 1
          $(".shopping-cart .items-list").remove()
          $(".shopping-cart .title").text "Ваша корзина пустая!"
        return

      return

    return


  #Wishlist Deleting Items
  # ******************************************
  $(document).on "click", ".wishlist .delete i", ->
    $target = $(this).parent().parent()
    $target.hide 300, ->
      $.when($target.remove()).then ->
        if $positions.length is 1
          $(".wishlist .items-list").remove()
          $(".wishlist .title").text "Wishlist is empty!"
        return

      return

    return


  #Catalog 3-rd Level Submenu positioning
  # ******************************************
  $(".catalog .submenu .has-submenu").hover (->
    $offseTop = $(this).position().top
    $(".catalog .submenu .offer .col-1 p").hide()
    $(this).find(".sub-submenu").css(top: -$offseTop + 12 + "px").show()
    return
  ), ->
    $(this).find(".sub-submenu").hide()
    $(".catalog .submenu .offer .col-1 p").show()
    return


  #Small Header slide down on scroll
  # ******************************************
  if $(window).width() >= 500
    $(window).on "scroll", ->
      if $(window).scrollTop() > $headerOffsetTop
        $header.addClass "small-header"
      else
        $header.removeClass "small-header"
      if $(window).scrollTop() > $headerStuck
        $header.addClass "stuck"
      else
        $header.removeClass "stuck"
      return


  #Mobile Navigation
  # ******************************************

  #Mobile menu toggle
  $menuToggle.click ->
    $menu.toggleClass "expanded"
    return


  #Submenu Toggle
  $submenuToggle.click (e) ->
    $(this).toggleClass "open"
    $(this).parent().parent().find(".submenu").toggleClass "open"
    e.preventDefault()
    return


  #Subscription Form Widget
  # ******************************************
  $subscrForm.validate()
  $nextField.click (e) ->
    $target = $(this).parent()
    if $subscrForm.valid() is true
      $target.hide "drop", 300, ->
        $target.next().show "drop", 300
        return

    e.preventDefault()
    return


  #Custom Style Checkboxes and Radios
  # ******************************************
  $("input").iCheck
    checkboxClass: "icheckbox"
    radioClass: "iradio"


  #Parallax Backgrounds
  # ******************************************
  $(window).on "load", ->

    #Checking if it's touch device we disable parallax feature due to inconsistency
    $("body").removeClass "parallax"  if Modernizr.touch
    $(".parallax").stellar
      horizontalScrolling: false
      responsive: true

    return


  #Features Tabs
  # ******************************************
  $featureTab.on "mouseover", ->
    $featureTab.removeClass "active"
    $(this).addClass "active"
    $curTab = $(this).attr("data-tab")
    $featureTabPane.removeClass "current"
    $(".feature-tabs .tabs-pane" + $curTab).addClass "current"
    return


  #Enable Touch / swipe events for carousel
  # ******************************************
  $(".carousel-inner").swipe

    #Generic swipe handler for all directions
    swipeRight: (event, direction, distance, duration, fingerCount) ->
      $(this).parent().carousel "prev"
      return

    swipeLeft: ->
      $(this).parent().carousel "next"
      return


    #Default is 75px, set to 0 for demo so any distance triggers swipe
    threshold: 0


  #Initializing Gallery Plugin
  # ******************************************
  # gallery.init()
  # $(".gallery-grid").lightGallery speed: 400

  #Initializing Brands Carousel Plugin
  # ******************************************
  $brandCarousel.owlCarousel

    # Define custom and unlimited items depending from the width
    # If this option is set, itemsDeskop, itemsDesktopSmall, itemsTablet, itemsMobile etc. are disabled
    # For better preview, order the arrays by screen size, but it's not mandatory
    # Don't forget to include the lowest available screen size, otherwise it will take the default one for screens lower than lowest available.
    # In the example there is dimension with 0 with which cover screens between 0 and 450px
    itemsCustom: [
      [
        0
        1
      ]
      [
        340
        2
      ]
      [
        580
        3
      ]
      [
        991
        4
      ]
      [
        1200
        5
      ]
    ]
    navigation: true
    theme: ""
    navigationText: [
      ""
      ""
    ]


  # #Hero Slider
  # # ******************************************
  # if $("#hero-slider").length > 0
  #   heroSlider = new MasterSlider()
  #   heroSlider.control "arrows"
  #   heroSlider.control "bullets"
  #   heroSlider.setup "hero-slider",
  #     width: 1140
  #     height: 455
  #     space: 0
  #     speed: 18
  #     autoplay: true
  #     loop: true
  #     layout: "fullwidth"
  #     preload: "all"
  #     view: "basic"
  #     instantStartLayers: true


  # #Hero Fullscreen Slider
  # # ******************************************
  # if $("#fullscreen-slider").length > 0
  #   fullscreenSlider = new MasterSlider()
  #   fullscreenSlider.control "arrows"
  #   fullscreenSlider.control "bullets"
  #   fullscreenSlider.setup "fullscreen-slider",
  #     width: 1140
  #     height: 455
  #     space: 0
  #     speed: 18
  #     autoplay: true
  #     loop: true
  #     layout: "fullscreen"
  #     fullscreenMargin: 144
  #     preload: "all"
  #     view: "mask"
  #     instantStartLayers: true


  #Category Slider
  # ******************************************
  if $("#cat-slider").length > 0
    categorySlider = new MasterSlider()
    categorySlider.control "thumblist",
      autohide: false
      dir: "h"
      type: "tabs"
      width: 164
      height: 280
      align: "bottom"
      space: 30
      margin: 13
      hideUnder: 400

    categorySlider.setup "cat-slider",
      width: 1050
      height: 550
      space: 0
      speed: 25
      layout: "fullwidth"
      preload: "all"
      view: "basic"
      instantStartLayers: true


  #Offers Tabs
  # ******************************************
  $offersTabs.click ->
    $offersTabs.removeClass "active"
    $(this).addClass "active"
    return

  $offersTabsCarousel.owlCarousel
    itemsCustom: [
      [
        0
        1
      ]
      [
        420
        2
      ]
      [
        880
        3
      ]
      [
        1200
        3
      ]
    ]
    navigation: false
    theme: ""


  #Catalog Sorting Toggles
  # ******************************************
  $sortToggle.click (e) ->
    $(this).toggleClass "sorted"
    e.preventDefault()
    return


  #Disabling link on active page
  # ******************************************
  $activePage.click (e) ->
    e.preventDefault()
    return


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


  #Categories accordion
  $subcatToggle.click (e) ->
    $(this).parent().toggleClass "opened"
    $(this).parent().find(".subcategory").toggleClass "open"
    e.preventDefault()
    return


  #Filter Toggle / Showing Filters in Modal
  $filterToggle.click ->
    $(".shop-filters").appendTo $("#filterModal .modal-body")
    $("#filterModal .modal-body .shop-filters").css "display", "block"
    return

  $("#filterModal").on "hide.bs.modal", ->
    $(".shop-filters").appendTo ".filters-mobile"
    return

  $(window).resize ->
    $("#filterModal").modal "hide"  if $(window).width() > 768
    return


  #Catalog Single
  # ******************************************

  # #Product Gallery
  # if $("#prod-gal").length > 0
  #   categorySlider = new MasterSlider()
  #   categorySlider.control "thumblist",
  #     autohide: false
  #     dir: "h"
  #     align: "bottom"
  #     width: 137
  #     height: 130
  #     margin: 15
  #     space: 0
  #     hideUnder: 400

  #   categorySlider.setup "prod-gal",
  #     width: 550
  #     height: 484
  #     speed: 25
  #     preload: "all"
  #     loop: true
  #     view: "fade"

  #Add(+/-) Button Number Incrementers
  $(".shopping-cart .incr-btn").on "click", (e) ->
    $button = $(this)
    e.preventDefault()
    input = '#line_item_quantity_' + $button.data('target')
    form = '#edit_line_item_' + $button.data('target')
    oldValue = $(input).val()
    limit = parseFloat($(input).data('limit'))
    if $button.text() is "+"
      if oldValue < limit
        newVal = parseFloat(oldValue) + 1
      else
        newVal = limit
    else
      # Don't allow decrementing below 1
      if oldValue > 1
        newVal = parseFloat(oldValue) - 1
      else
        newVal = 1
    $(input).val newVal
    $button.closest(form).submit()
    return

  #Add(+/-) Button Number Incrementers
  $(".product-page .incr-btn").on "click", (e) ->
    $button = $(this)
    e.preventDefault()
    input = '#' + $button.data('target')
    oldValue = $(input).val()
    limit = parseFloat($('#select_characteristic_quantity').data('limit'))
    $('#offer_limit').val(limit)
    if $button.text() is "+"
      if oldValue < limit
        newVal = parseFloat(oldValue) + 1
      else
        newVal = limit
    else
      # Don't allow decrementing below 1
      if oldValue > 1
        newVal = parseFloat(oldValue) - 1
      else
        newVal = 1
    $(input).val newVal
    return

  #Added To Cart Message + Action (For Demo Purpose)
  # *************************************************
  $addToCartBtn.click ->
    $addedToCartMessage.removeClass "visible"
    $itemName = $(this).parent().parent().find("h1").text()
    $itemPrice = $(this).parent().parent().find(".price").text()
    $itemQnty = $(this).parent().find("#quantity").val()
    $cartTotalItems = parseInt($(".cart-btn a span").text()) + 1
    $addedToCartMessage.find("p").text "\"" + $itemName + "\"" + "  " + "was successfully added to your cart."
    $(".cart-dropdown table").append "<tr class=\"item\"><td><div class=\"delete\"></div><a href=\"#\">" + $itemName + "<td><input type=\"text\" value=\"" + $itemQnty + "\"></td><td class=\"price\">" + $itemPrice + "</td>"
    $(".cart-btn a span").text $cartTotalItems
    $addedToCartMessage.addClass "visible"
    return


  #Promo Labels Popovers
  # ******************************************
  $promoLabels.popover
    placement: "top"
    trigger: "hover"


  #Special Offer Autoheight
  # ******************************************
  $(window).load ->
    tileH = $(".special-offer .tile").height()
    $(".special-offer .offer").css "height", tileH
    return

  $(window).resize ->
    tileH = $(".special-offer .tile").height()
    $(".special-offer .offer").css "height", tileH
    return


  #Expandable Panels
  # ******************************************
  $panelToggle.click (e) ->
    $(this).toggleClass "active"
    $target = $(this).attr("href")
    $($target).toggleClass "expanded"
    e.preventDefault()
    return


  #Accordion Widget
  # ******************************************
  $accordionToggle.click ->
    $accordionToggle.parent().removeClass "active"
    $(this).parent().addClass "active"
    return


  #Sticky Buttons
  # ******************************************

  #Scroll to Top Button
  $(window).scroll ->
    if $(this).scrollTop() > 500
      $scrollTopBtn.parent().addClass "scrolled"
    else
      $scrollTopBtn.parent().removeClass "scrolled"
    return

  $scrollTopBtn.click ->
    $("html, body").animate
      scrollTop: 0
    ,
      duration: 700
      easing: "easeOutExpo"

    return


  #Quick Contact Form
  $qcfBtn.click ->
    $(this).toggleClass "active"
    $(this).parent().find(".quick-contact").toggleClass "visible"
    return

  $(".page-content, .subscr-widget, footer, header").click ->
    $qcfBtn.removeClass "active"
    $(".quick-contact").removeClass "visible"
    return

