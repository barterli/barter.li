'use strict';

barterApp.directive('autosuggest', function($timeout, $http) {
     return {
       restrict: "E",
       scope: {
        modelupdate:"=",
        suggestions:"=",
        urlsend:"@"
       },
    template: '<ul><li ng-repeat="suggest in suggestions" ng-click="updateModel(suggest)">{{suggest}}</li></ul>',
    link: function (scope, element) {
     var modelelement = angular.element(element.prev());
     scope.send_suggest = true
      scope.$watch('modelupdate', function() { 
         	if(scope.send_suggest && scope.modelupdate != "")
         	{
         		 var send_query = {
                  q:scope.modelupdate
                 };
         	  $timeout(function(){ $http.post(scope.urlsend, send_query).then(function(data){
                 scope.suggestions = data.data;
         	  }), 3000});
         	}
      });

      modelelement.bind("focus", function () {
         scope.send_suggest = true;
      });

      scope.updateModel = function(value){
      	 scope.send_suggest = false;
         scope.modelupdate = value; 
         scope.suggestions = ""
         scope.$parent.getBookInfo(value);
         
      }
   }
   };

 });


