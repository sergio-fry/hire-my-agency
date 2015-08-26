var JobsController = angular.module('JobsController', ['JobsService', 'EmployeesService', 'ngTable']);


JobsController.controller("JobsList",  ['$scope', '$routeParams', 'Jobs', 'ngTableParams', '$http', function ($scope, $routeParams, Jobs, ngTableParams, $http) {
  $scope.jobs = Jobs.query()

  $http.get("/jobs/total.json").then(function(resp) {

    $scope.tableParams = new ngTableParams({
      page: 1,            // show first page
      count: 10           // count per page
    }, {
      total: resp.data.total, // length of data
      getData: function ($defer, params) {
        $defer.resolve(Jobs.query({page: params.page(), per_page: params.count()}));
      }
    })
  });
}])

.controller("JobDisplay",  ['$scope', '$routeParams', 'Jobs', 'Employees', 'ngTableParams', '$http', function ($scope, $routeParams, Jobs, Employees, ngTableParams, $http) {
  $scope.job = Jobs.get({ id: $routeParams.id })

  $scope.job.$promise.then(function() {
    $http.get("/employees/total.json", { params: { "skills[]": $scope.job.skill_ids, status: 0 } }).then(function(resp) {

      $scope.tableParams = new ngTableParams({
        page: 1,            // show first page
        count: 10           // count per page
      }, {
        total: resp.data.total, // length of data
        getData: function ($defer, params) {
          $defer.resolve(Employees.query({"skills[]": $scope.job.skill_ids, status: 0, page: params.page(), per_page: params.count()}));
        }
      })
    });

  })
}])

.controller("JobEdit",  ['$scope', '$routeParams', 'Jobs', function ($scope, $routeParams, Jobs) {
  $scope.job = Jobs.get({ id: $routeParams.id })
}])
