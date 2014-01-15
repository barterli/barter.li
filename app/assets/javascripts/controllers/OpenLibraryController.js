barterApp.controller('openLibraryCtrl', ['$scope','$http',function ($scope,$http) {
    $scope.title = "";
    $scope.getBookInfo = function(value){
      if(value == "" || value == " ")
      {
      	return;
      }
      $http.get('/book_info.json?q='+value).then(function(res){
        if(Object.keys(res).length !== 0)
        {
           data = res.data
           console.log(data);
           $scope.author = $scope.getAuthors(data.authors)
           $scope.isbn_13 = data.isbn13;
           $scope.isbn_10 = data.isbn;
           $scope.publication_year = data.publication_year
           $scope.publication_month = data.publication_month
           // $scope.edition = data.edition_count;
           $scope.publisher = data.publisher;
          
        }
      });
    }
        
     $scope.getAuthors = function(data){
      names = new Array();
      console.log(data.author.name);
      if (typeof(data.author.name) != 'undefined')
      {
        return data.author.name;
      }
      angular.forEach(data.author, function(value, key){
         names.push(value.name);
       });
      return names.join(",");
     }
}]);
