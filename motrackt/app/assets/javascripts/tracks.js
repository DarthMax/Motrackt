$(document).ready(function(){
  $('#details').collapse();

  $('#details').on('shown',function(){
    $('#details-header').removeClass("icon-chevron-up");
    $('#details-header').addClass("icon-chevron-down");
  });

  $('#details').on('hidden', function(){
    $('#details-header').removeClass("icon-chevron-down");
    $('#details-header').addClass("icon-chevron-up");
  });
});