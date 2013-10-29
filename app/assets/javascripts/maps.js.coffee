#######################################################
# Map
# The main class that provides access to the google map
#######################################################
class Map

  ###
  # Returns the InfoWindow that is attached to the google maps
  ###
  _get_info_window: () ->
    if @_info_window != undefined
      return @_info_window
    @_info_window = new google.maps.InfoWindow
      content: ""
      maxWidth: 200
    return @_info_window

  constructor: () ->
    myOptions =
      zoom: 4
      center : new google.maps.LatLng(0,0)
      mapTypeId: google.maps.MapTypeId.TERRAIN

    @google_map_instance = new google.maps.Map document.getElementById("map"), myOptions

window.Map=Map




####################################################
# VehicleMaü
# Extended class for drawing tracks on a google map
####################################################
class TrackMap extends Map
  @markers: []

  ###
  # Toggles the waypoint marker visibility
  ###
  toggle_marker: () ->
    visibility = !(@markers[0].getVisible());
    $.each @markers, (i,marker) ->
      marker.setVisible(visibility)

  ###
  # Generatest waypoint marker for each stored position
  ###
  _marker_from_position: (position) ->
    latLon = new google.maps.LatLng position.lat, position.lon
    marker = new google.maps.Marker
      position: latLon
      map: @google_map_instance
      title: position.lat + " " + position.lon
      position_data: position
      visible:false

    marker.position_data = position;
    google.maps.event.addListener marker,'click', () =>
      @show_position_data(marker)
    return marker

  ###
  # Displays a markers meta data in a InfoWindow
  ###
  show_position_data: (marker) ->
    position = marker.position_data
    info_window = @_get_info_window()
    console.log info_window

    text=
      """
      <h5>#{position.time}</h5>
      <dl>
        <dt> Coordinates </dt>
        <dd> Longitude: #{position.lon} </dd>
        <dd> Latitude: #{position.lat} </dd>
        <dt> Speed </dt>
        <dd> #{position.speed} km/h</dd>
        <dt> Height </dt>
        <dd> #{position.height} m</dd>
      </dl>
      """
    info_window.setContent text

    info_window.open(@google_map_instance,marker)

  constructor: (@positions) ->
    super
    @markers = (@_marker_from_position(position) for position in @positions)
    path = (new google.maps.LatLng(position.lat, position.lon) for position in @positions)

    track = new google.maps.Polyline
      path: path
      strokeColor: "#FF0000"
      strokeOpacity: 1.0
      strokeWeight: 2
    @google_map_instance.setCenter(path[0]);
    track.setMap(@google_map_instance);

window.TrackMap = TrackMap




################################################
# VehicleMap
# Provides a map that show the user position and
# the vehicles last known position
################################################
class VehicleMap extends Map
  marker_user: ''
  marker_bike: ''

  ###
  # Set up the Users Position
  ###
  _initialize_user_position: () ->
    @marker_user=new google.maps.Marker
      map: @google_map_instance,
      title: "Here are you"

    navigator.geolocation.watchPosition (position) =>
      console.log this
      latlng = new google.maps.LatLng position.coords.latitude, position.coords.longitude
      @marker_user.setPosition latlng


  ####
  # Set the initial vehicle position
  ####
  _initialize_vehicle_position: (lat,lng) ->
    latlng = new google.maps.LatLng lat, lng
    @marker_bike=new google.maps.Marker
      map: @google_map_instance
      position : latlng
      title: "Here is your bike"

    @google_map_instance.setCenter(latlng);

  ###
  # Keep the vehicles position updated
  ###
  _update_vehicle_position: (vehicle_id) ->
    window.setInterval () =>
      $.getJSON vehicle_id+".json", (data) =>
        if position = data.vehicle.last_position
          latlng = new google.maps.LatLng(position.latitude,position.longitude)
          @marker_bike.setPosition(latlng)
          @google_map_instance.setCenter(latlng)
    ,20000

  constructor: (vehicle_lat,vehicle_lon,vehicle_id) ->
    super
    @._initialize_vehicle_position(vehicle_lat,vehicle_lon)
    @_initialize_user_position()
    @_update_vehicle_position(vehicle_id)

window.VehicleMap = VehicleMap
