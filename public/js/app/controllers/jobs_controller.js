var JobsController = angular.module('JobsController', ['JobsService', 'EmployeesService', 'ngTable', 'ngTagsInput']);


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
    var employees_params = { "skills[]": $scope.job.skills.map(function(s) { return s.id }), status: 0, salary: $scope.job.salary }
    $http.get("/employees/total.json", { params: employees_params }).then(function(resp) {

      $scope.tableParams = new ngTableParams({
        page: 1,            // show first page
        count: 10           // count per page
      }, {
        total: resp.data.total, // length of data
        getData: function ($defer, params) {
          $defer.resolve(Employees.query($.extend({}, employees_params, { page: params.page(), per_page: params.count()})));
        }
      })
    });
  })
}])

.controller("JobEdit",  ['$scope', '$routeParams', 'Jobs', '$location', '$http', function ($scope, $routeParams, Jobs, $location, $http) {
  $scope.job = Jobs.get({ id: $routeParams.id })


  $scope.save = function() {
    $scope.errors = [];

    $scope.job.skills_list = $scope.job.skills.map(function(s){ return s.title}).join(", ")

    Jobs.save({ id: $scope.job.id, job: $scope.job }).$promise.then(function() {
      $location.url("jobs/" + $scope.job.id)
    }, function(error) {
      for(attr in error.data.errors) {
        $scope.errors.push(attr + ": " + error.data.errors[attr].join(", "))
      }
    });
  }
  
  $scope.loadSkills = function(query) {
    return $http.get('/skills/search.json?query=' + query);
  };

}])

.controller("JobNew",  ['$scope', '$routeParams', 'Jobs', '$location', '$http', function ($scope, $routeParams, Jobs, $location, $http) {
  $scope.job = {skills: []}

  $scope.save = function() {
    $scope.errors = [];

    $scope.job.skills_list = $scope.job.skills.map(function(s){ return s.title}).join(", ")

    Jobs.create({ job: $scope.job }).$promise.then(function(data) {
      $location.url("jobs/" + data.id)
    }, function(error) {
      for(attr in error.data.errors) {
        $scope.errors.push(attr + ": " + error.data.errors[attr].join(", "))
      }
    });
  }
  
  $scope.loadSkills = function(query) {
    return $http.get('/skills/search.json?query=' + query);
  };
}])
