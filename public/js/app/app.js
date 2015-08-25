var HireMeApp = angular.module('HireMeApp', ['ngRoute']);


HireMeApp.config(function($routeProvider) {
  $routeProvider
  .when('/', {
    controller:'JobsListController as JobsList',
    templateUrl:'/js/app/templates/jobs/index.html',
  })
})

.controller('JobsListController', function ($scope) {
  $scope.jobs = [
    {'title': 'Nexus S'},
    {'title': 'Nexus B'},
    {'title': 'Nexus N'},
  ];
});
