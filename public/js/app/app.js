var HireMeApp = angular.module('HireMeApp', ['ngRoute', 'JobsController', 'ngTable']);


HireMeApp.config(function($routeProvider) {
  $routeProvider

  .when('/', {
    controller:'JobsList',
    templateUrl:'/js/app/templates/jobs/index.html',
  })

  .when('/jobs/:id', {
    controller:'JobDisplay',
    templateUrl:'/js/app/templates/jobs/show.html',
  })

  .when('/jobs/:id/edit', {
    controller:'JobEdit',
    templateUrl:'/js/app/templates/jobs/edit.html',
  })
})
