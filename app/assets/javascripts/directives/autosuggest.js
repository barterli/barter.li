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
     scope.que = false
     scope.makecall = function(){
         var send_query = {
                  q:scope.modelupdate
                 };
        $http.post(scope.urlsend, send_query).then(function(data){
                 scope.suggestions = data.data;
                 if(scope.que)
                 {
                  scope.que = false;
                  scope.makecall(); 
                 }
            })
       }
      scope.$watch('modelupdate', function() { 
         	if(scope.send_suggest && scope.modelupdate != "" && scope.modelupdate.length > 3 && (scope.modelupdate.length % 2) == 0 )
         	{
             if($http.pendingRequests.length > 0)
             {
              scope.que = true;
              return;
             }
             else
             {
              scope.makecall();
             }
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


