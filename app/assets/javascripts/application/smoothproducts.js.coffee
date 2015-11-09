$ ->
  if $(".sp-wrap").present()
    alert 'present'
    $(".sp-wrap").append "<div class=\"sp-large\"></div><div class=\"sp-thumbs sp-tb-active\"></div>"
    $(".sp-wrap a").appendTo ".sp-thumbs"
    $(".sp-thumbs a:first").addClass("sp-current").clone().removeClass("sp-current").appendTo ".sp-large"
    $(".sp-wrap").css "display", "inline-block"
    slideTiming = 300
    maxWidth = $(".sp-large img").width()
    $(".sp-thumbs").live "click", (e) ->
      e.preventDefault()
      return

    $(".sp-tb-active a").live "click", (e) ->
      $(".sp-current").removeClass()
      $(".sp-thumbs").removeClass "sp-tb-active"
      $(".sp-zoom").remove()
      t = $(".sp-large").height()
      $(".sp-large").css
        overflow: "hidden"
        height: t + "px"

      $(".sp-large a").remove()
      $(this).addClass("sp-current").clone().hide().removeClass("sp-current").appendTo(".sp-large").fadeIn slideTiming, ->
        e = $(".sp-large img").height()
        $(".sp-large").height(t).animate
          height: e
        , "fast", ->
          $(".sp-large").css "height", "auto"
          return

        $(".sp-thumbs").addClass "sp-tb-active"
        return

      e.preventDefault()
      return

    $(".sp-large a").live "click", (e) ->
      t = $(this).attr("href")
      $(".sp-large").append "<div class=\"sp-zoom\"><img src=\"" + t + "\"/></div>"
      $(".sp-zoom").fadeIn()
      $(".sp-large").css
        left: 0
        top: 0

      e.preventDefault()
      return

    $(document).ready ->
      $(".sp-large").mousemove((e) ->
        t = $(".sp-large").width()
        n = $(".sp-large").height()
        r = $(".sp-zoom").width()
        i = $(".sp-zoom").height()
        s = $(this).parent().offset()
        o = e.pageX - s.left
        u = e.pageY - s.top
        a = Math.floor(o * (t - r) / t)
        f = Math.floor(u * (n - i) / n)
        $(".sp-zoom").css
          left: a
          top: f

        return
      ).mouseout ->

      return

    $(".sp-zoom").live "click", (e) ->
      $(this).fadeOut ->
        $(this).remove()
        return

      return
