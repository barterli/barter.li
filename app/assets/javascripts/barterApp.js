
var barterApp;

barterApp = angular.module('barterApp', ['ngResource']);

//rails csrf token in ajax requests
barterApp.config(function($httpProvider) {
  var authToken;
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  return $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
});


//angular to work with turbolinks
$(document).on('page:load', function() {
  return $('[ng-app]').each(function() {
    var module;
    module = $(this).attr('ng-app');
    return angular.bootstrap(this, [module]);
  });
});



