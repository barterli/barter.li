barterApp.controller('serverCtrl', ['$scope', 'WishList', function ($scope, WishList ) {
    $scope.wishlist = "";
    $scope.sendWishList = function(){
       var  wish_list_promise= WishList.saveWishList('title', $scope.wishlist);
       wish_list_promise.success(function (data, status, headers, config) {
             console.log(data);
          });
       wish_list_promise.error(function (data, status, headers, config) {
             console.log(data);
          });       
    }
   
}]);





