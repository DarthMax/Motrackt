// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

var map;
var markers = [];

var marker_user;
var marker_bike;


function draw_map() {
    var myOptions = {
        zoom: 4,
        center : new google.maps.LatLng(0,0),
        mapTypeId: google.maps.MapTypeId.TERRAIN
    };

    map = new google.maps.Map(document.getElementById("map"),
        myOptions);


}


function draw_track(positions) {
    path = [];
    $.each(positions,function(index,position){
        var latLon = new google.maps.LatLng(position.lat,position.lon);
        path.push(latLon);

        var marker = new google.maps.Marker({
            position: latLon,
            map: map,
            title: position.lat + " " + position.lon,
            position_data: position,
            visible:false
        });
        marker.position_data = position;
        google.maps.event.addListener(marker,'click',show_position_data);
        markers.push(marker);
    });

    var track = new google.maps.Polyline({
        path: path,
        strokeColor: "#FF0000",
        strokeOpacity: 1.0,
        strokeWeight: 2
    });
    map.setCenter(path[0]);
    track.setMap(map);
}


function show_position_data() {
    var info_window = get_info_window();
    var position = this.position_data;
    info_window.setContent(
        '<h5>' + position.time + '</h5>'
        + '<dl>'
            + '<dt> Coordinates </dt>'
            + '<dd> Longitude: ' + position.lon + '</dd>'
            + '<dd> Latitude: ' + position.lat + '</dd>'
            + '<dt> Speed </dt>'
            + '<dd>' + position.speed + 'km/h</dd>'
            + '<dt> Height </dt>'
            + '<dd>' + position.height + 'm</dd>'
        + '</dl>'
    );
    info_window.open(map,this);
}

function get_info_window() {
    if(window.info_window != undefined) {
        return window.info_window;
    }
    window.info_window = new google.maps.InfoWindow({
        content: "",
        maxWidth: 200
    });

    return window.info_window;
}

function toggle_marker () {
    var visibility = !(markers[0].getVisible());
    $.each(markers,function(i,marker){
        marker.setVisible(visibility);
    });
}



function initialize_user_position() {
    marker_user=new google.maps.Marker({
        map: map,
        title: "Here are you"
    });

    navigator.geolocation.watchPosition(function(position) {
        var latlng = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
        marker_user.setPosition(latlng);
    });
}


function initialize_bike_position(lat,lng,vehicle_id) {
    var latlng = new google.maps.LatLng(lat,lng);
    marker_bike=new google.maps.Marker({
        map: map,
        position : latlng,
        title: "Here is your bike"
    });

    map.setCenter(latlng);

    update_position(vehicle_id);
}

function update_position(vehicle_id) {
    $.getJSON(vehicle_id+".json", function(data) {
            var position;
            if(position=data.vehicle.last_position) {
                var latlng = new google.maps.LatLng(position.latitude,position.longitude);
                marker_bike.setPosition(latlng);
                map.setCenter(latlng);
            }
        }
    );
    window.setTimeout(function(){update_position(vehicle_id)},20000);
}
