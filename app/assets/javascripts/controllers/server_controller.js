barterApp.controller('serverCtrl', ['$scope', 'WishList', 'geolocation','Geocoder', function ($scope, WishList, geolocation, Geocoder) {
    $scope.wishlist = "";
    $scope.currentLocation = function(){
      geolocation.getLocation().then(function(data){
      $scope.coords = {lat:data.coords.latitude, lng:data.coords.longitude};
      Geocoder.addressForLatLng(data.coords.latitude, data.coords.longitude).then(function(data){
        //["Eshwara Layout", " Indira Nagar", " Bangalore", " Karnataka", " India"] 
        console.log(data.address.split(","));
         $scope.currentUserLocation = data.address;
       });
     });

    }
    $scope.sendWishList = function(){
       var  wish_list_promise= WishList.saveWishList('title', $scope.wishlist);
       wish_list_promise.success(function (data, status, headers, config) {
             console.log(data);
          });
       wish_list_promise.error(function (data, status, headers, config) {
             console.log(data);
          });       
    }

    $scope.sendSearch = function(){
      window.location = "/search?search="+$scope.search_query; 
    }

}]);





