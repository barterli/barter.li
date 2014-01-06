// call to server to add wishlist
angular.module('barter_server', [])
.factory('WishList', ['$http', function($http){
  return {
    saveWishList: function(column, word){
       var send_word = {
        wish_list: {column:word},
      };
      return $http.post('/wish_list.json', send_word);
    }
  }
}]);