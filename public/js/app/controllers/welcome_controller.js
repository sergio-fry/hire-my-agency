var WelcomeController = angular.module('WelcomeController', []);


EmployeesController.controller("WelcomeController",  ['$scope', '$http', function ($scope, $http) {
  $http.get("/jobs/total.json").then(function(resp) {
    $scope.jobs_total = resp.data.total;
  })

  $http.get("/employees/total.json").then(function(resp) {
    $scope.employees_total = resp.data.total;
  })
}])

