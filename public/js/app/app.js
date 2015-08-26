var HireMeApp = angular.module('HireMeApp', ['ngRoute', 'WelcomeController', 'JobsController', 'EmployeesController', 'ngTable']);


HireMeApp.config(function($routeProvider) {
  $routeProvider

  .when('/', {
    controller:'WelcomeController',
    templateUrl:'/js/app/templates/welcome/index.html',
  })

  .when('/jobs', {
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

  .when('/employees', {
    controller:'EmployeesList',
    templateUrl:'/js/app/templates/employees/index.html',
  })

  .when('/employees/:id', {
    controller:'EmployeeDisplay',
    templateUrl:'/js/app/templates/employees/show.html',
  })

  .when('/employees/:id/edit', {
    controller:'EmployeeEdit',
    templateUrl:'/js/app/templates/employees/edit.html',
  })
})

.filter('is_future', function() {
  return function(input) {
    return new Date(input) > new Date();
  }
})
