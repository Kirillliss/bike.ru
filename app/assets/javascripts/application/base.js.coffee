jQuery.fn.present = ->
  @length > 0
  
$ ->
  if $(".bxslider").exist()
    $(".bxslider").bxSlider
      auto: true
      pause: 3000
      pager: false
      controls: true

