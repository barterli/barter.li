angular.module('barterApp',['geolocation'])
  .controller('geoCtrl', function ($scope,geolocation) {
    geolocation.getLocation().then(function(data){
      $scope.coords = {lat:data.coords.latitude, long:data.coords.longitude};
      
    });
});
