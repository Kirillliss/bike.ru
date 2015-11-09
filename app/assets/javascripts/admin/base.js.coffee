# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@initCkditr = ->
  $( '.ckedtr' ).ckeditor
    # uiColor: '#d8d2c6'
    toolbar_Basic: [["Bold", "Italic", "-", "NumberedList", "BulletedList", 'Outdent','Indent', 'Table']]
    toolbar: "Basic"
    language: 'ru'
    height: "233px"
    contentsCss: "<%= asset_path('ckeditor/contents.css') %>"
    pasteFromWordRemoveFontStyles: true
    resize_enabled: true

checkProjects = ->
  if $("#page_everywhereable").is(":checked")
    $("#page_projects").attr("disabled", "disabled")
  else
    $("#page_projects").removeAttr("disabled")
  return

$ ->
  $('.select2').select2()

  $(".bxslider").bxSlider
    responsive: false
    slideWidth: 400

  $("#page_everywhereable").click ->
    checkProjects()
  checkProjects()

  initCkditr()

  $(".summernote").summernote
    height: 400
    toolbar: [
      #[groupname, [button list]]
      [
        "style"
        [
          "bold"
          "italic"
          "underline"
          "clear"
        ]
      ]
      [
        "font"
        ["strikethrough"]
      ]
      [
        "fontsize"
        ["fontsize"]
      ]
      [
        "color"
        ["color"]
      ]
      [
        "para"
        [
          "ul"
          "ol"
          "paragraph"
        ]
      ]
      [
        "height"
        ["height"]
      ]
      [
        "insert"
        ["video"]
      ]
    ]

  $(".datatable").dataTable
    language:
      url: '//cdn.datatables.net/plug-ins/725b2a2115b/i18n/Russian.json'
    # ajax: ...,
    # autoWidth: false,
    # pagingType: 'full_numbers',
    # processing: true,
    # serverSide: true,

    # Optional, if you want full pagination controls.
    # Check dataTables documentation to learn more about available options.
    # http://datatables.net/reference/option/pagingType