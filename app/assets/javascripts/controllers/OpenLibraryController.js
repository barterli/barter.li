barterApp.controller('openLibraryCtrl', ['$scope','$http',function ($scope,$http) {
    $scope.title = "";
    $scope.getBookInfo = function(){
      if($scope.title == "" || $scope.title == " ")
      {
      	return;
      }
      $http.get('/book_info.json?q='+$scope.title).then(function(res){
        if($.isArray(res.data) ||  res.data.length)
        {
          var data = res.data[0];
          console.log(data);
          $scope.author = data.author_name.join(",");
          $scope.isbn_13 = data.isbn[0];
          $scope.isbn_10 = data.isbn[1];
          $scope.publication_year = data.publish_year[0];
          $scope.publication_month = data.publish_date[0].split(" ")[0];
          console.log($scope.publication_month);
          $scope.edition = data.edition_count;
          $scope.publisher = data.publisher[0];
          $scope.goodreads_id = data.id_goodreads[0];
        }
      });
    }
  
}]);
