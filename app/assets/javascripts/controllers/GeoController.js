angular.module('barterApp',['geolocation', 'geocoder'])
  .controller('geoCtrl', function ($scope,geolocation,Geocoder ) {
    geolocation.getLocation().then(function(data){
      $scope.coords = {lat:data.coords.latitude, lng:data.coords.longitude};
      Geocoder.addressForLatLng(data.coords.latitude, data.coords.longitude).then(function(data){
      	//["Eshwara Layout", " Indira Nagar", " Bangalore", " Karnataka", " India"] 
      	console.log(data.address.split(","));
      	$scope.location_array = data.address.split(",");
      	$scope.saveLocation();
      });
      
    });
     $scope.saveLocation= function(){
       var location = $scope.location_array;
       $scope.country = location[4].trim();
       $scope.state = location[3].trim();
       $scope.city = location[2].trim();
       $scope.locality = location[1].trim();
       $scope.street = location[0].trim();
       $scope.latitude = $scope.coords.lat;
       $scope.longitude = $scope.coords.lng;
       
     }
   
});
