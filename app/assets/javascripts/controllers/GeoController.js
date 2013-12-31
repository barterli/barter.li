angular.module('barterApp',['geolocation', 'geocoder'])
  .controller('geoCtrl', function ($scope,geolocation,Geocoder ) {
    geolocation.getLocation().then(function(data){
      $scope.coords = {lat:data.coords.latitude, long:data.coords.longitude};
      Geocoder.addressForLatLng(data.coords.latitude, data.coords.longitude).then(function(data){
      	console.log(data)
      })
      
    });
});
