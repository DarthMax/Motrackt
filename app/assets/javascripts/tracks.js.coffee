$(document).ready () ->
  $('#details').collapse()

  $('#details').on 'shown', () ->
    $('#details-header').removeClass("icon-chevron-up")
    $('#details-header').addClass("icon-chevron-down")

  $('#details').on 'hidden', () ->
    $('#details-header').removeClass("icon-chevron-down")
    $('#details-header').addClass("icon-chevron-up")



setupTrackChart = (chart_data) ->
  canvas = $("#track_height_chart")
  newWidth = canvas.parent().width()
  canvas.prop
    width: newWidth
    height: 200
  ctx = canvas.get(0).getContext("2d")
  new Chart(ctx).Line chart_data, animation:false

window.initTrackChart = (id) ->
  $.getJSON "/tracks/"+id+"/chart_data.json", (chart_data) ->
    setupTrackChart(chart_data)
    $(window).resize () ->
      setupTrackChart(chart_data)





