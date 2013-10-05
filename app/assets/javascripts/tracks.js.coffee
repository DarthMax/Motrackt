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



# If a Track in the Tracklist is selected/deselected toggle the tools buttons
$(document).on "click", "input[name='track_ids[]']", () ->
  selected_tracks = $("input[name='track_ids[]']:checked").size()

  if selected_tracks >= 2 then $("#merge_link").removeClass("disabled")
  if selected_tracks < 2 then  $("#merge_link").addClass("disabled")


# If the "Merge Tracks" Button is clicked check if there are at least 2 tracks selected and submit the form in case
$(document).on "click", "#merge_link", () ->
  selected_tracks = ($(box).val() for box in $("input[name='track_ids[]']:checked"))
  if selected_tracks.length >=2
    $("#track_form").attr("action","/tracks/merge").submit()
  else
    alert("Please select at least 2 Tracks to merge!")



