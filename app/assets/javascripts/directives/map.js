'use strict';

barterApp.directive('map',['Geocoder', function(Geocoder) {
     return {
       restrict: "E",
       scope: {
        mapattributes:"="
       },
    template: '<div id="map-canvas" style="width:{{mapattributes.width}};height:{{mapattributes.height}};position:absolute"></div>',
    link: function (scope, element) {
          var marker;
          scope.title = scope.mapattributes.title;
          scope.myLatlng = new google.maps.LatLng(scope.mapattributes.lat, scope.mapattributes.lng);
          scope.mapOptions = {
            zoom: 8,
            center: scope.myLatlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControl: true,
            panControl: true,
            zoomControl: true,
            zoomControlOptions: {
               style: google.maps.ZoomControlStyle.DEFAULT
             },
            scaleControl: true,
            streetViewControl: true,
            overviewMapControl: true

          }
         scope.placeMaker = function(location){
          marker = new google.maps.Marker({
           position: location,
           map: scope.map,
           title: scope.title
           });
            scope.map.setCenter(location);
           }
         scope.map = new google.maps.Map(document.getElementById("map-canvas"), scope.mapOptions);
         scope.placeMaker(scope.myLatlng);
          google.maps.event.addListener(scope.map, 'dblclick', function(event) {
            Geocoder.addressForLatLng(event.latLng.d, event.latLng.e).then(function(data){
            marker.setMap(null);
            scope.title = data.address;
            scope.placeMaker(event.latLng);
            scope.$parent.map_address_callback(data);
           });
          });
       }
   };

 }]);


