barterApp.controller('mapsProfileCtrl', ['$scope', function ($scope) {
    $scope.setattributes = function(lat, lng, address){
    $scope.map_attributes = {
      width: "50%",
      height: "50%",
      lat: lat, 
      lng: lng,
      title: address
    };
  };
    $scope.map_address_callback = function(data){
      console.log(data);
      angular.forEach(data.details.address_components, function(value, key){
              if (value.types[0] == "country"){ 
                $scope.country = value.long_name;
            }
              if (value.types[0] == "locality"){ 
                $scope.city = value.long_name;
            }
              if (value.types[0] == "administrative_area_level_2"){ 
                $scope.city = value.long_name;
            }
               if (value.types[0] == "sublocality"){ 
                $scope.locality = value.long_name;
            }

         });
           
    }

   
}]);


