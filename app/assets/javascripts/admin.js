// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery.mjs.nestedSortable
//= require bxslider
//= require twitter/bootstrap
//= require bootstrap
//= require admin/sortable
//= require cocoon
//= require admin/summernote.min
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require turbolinks
//= require select2
//= require admin/base


$(document).on('page:fetch', function() {
  $(".loading-indicator").show();
});

$(document).on('page:change', function() {
  $(".loading-indicator").hide();
  // $('.chosen').chosen();

  // $('.select2').select2();

});
