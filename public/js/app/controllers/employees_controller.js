var EmployeesController = angular.module('EmployeesController', ['JobsService', 'EmployeesService', 'ngTable', 'ngTagsInput']);


EmployeesController.controller("EmployeesList",  ['$scope', '$routeParams', 'Employees', 'ngTableParams', '$http', function ($scope, $routeParams, Employees, ngTableParams, $http) {
  $scope.employees = Employees.query()

  $http.get("/employees/total.json").then(function(resp) {

    $scope.tableParams = new ngTableParams({
      page: 1,            // show first page
      count: 10           // count per page
    }, {
      total: resp.data.total, // length of data
      getData: function ($defer, params) {
        $defer.resolve(Employees.query({page: params.page(), per_page: params.count()}));
      }
    })
  });
}])

.controller("EmployeeDisplay",  ['$scope', '$routeParams', 'Jobs', 'Employees', 'ngTableParams', '$http', function ($scope, $routeParams, Jobs, Employees, ngTableParams, $http) {
  $scope.employee = Employees.get({ id: $routeParams.id })

  $scope.employee.$promise.then(function() {
    var jobs_params = { "skills[]": $scope.employee.skills.map(function(s) { return s.id }), active: true, salary: $scope.employee.salary }

    $http.get("/jobs/total.json", { params: jobs_params }).then(function(resp) {
      $scope.MatchedJobs = new ngTableParams({
        page: 1,            // show first page
        count: 10           // count per page
      }, {
        total: resp.data.total, // length of data
        getData: function ($defer, params) {
          $defer.resolve(Jobs.query($.extend({}, jobs_params, {page: params.page(), per_page: params.count()})));
        }
      })
    });

    var related_jobs_params = $.extend({}, jobs_params, { match: 0.75 })

    $http.get("/jobs/total.json", { params: related_jobs_params }).then(function(resp) {

      $scope.RelatedJobs = new ngTableParams({
        page: 1,            // show first page
        count: 10           // count per page
      }, {
        total: resp.data.total, // length of data
        getData: function ($defer, params) {
          $defer.resolve(Jobs.query($.extend({}, related_jobs_params, { page: params.page(), per_page: params.count()})));
        }
      })
    });

  })
}])

.controller("EmployeeEdit",  ['$scope', '$routeParams', 'Employees', '$location', '$http', function ($scope, $routeParams, Employees, $location, $http) {
  $scope.employee = Employees.get({ id: $routeParams.id })

  $scope.save = function() {
    $scope.errors = [];

    $scope.employee.skills_list = $scope.employee.skills.map(function(s){ return s.title}).join(", ")

    Employees.save({ id: $scope.employee.id, employee: $scope.employee }).$promise.then(function() {
      $location.url("employees/" + $scope.employee.id)
    }, function(error) {
      for(attr in error.data.errors) {
        $scope.errors.push(attr + ": " + error.data.errors[attr].join(", "))
      }
    });
  }
  
  $scope.loadSkills = function(query) {
    return $http.get('/skills/search.json?query=' + query);
  };

  $scope.status_options = [
    { value: "0", text: "Need Job"},
    { value: "1", text: "Has Job!"},
  ]
}])

// https://docs.angularjs.org/api/ng/directive/select
.directive('convertToNumber', function() {
  return {
    require: 'ngModel',
    link: function(scope, element, attrs, ngModel) {
      ngModel.$parsers.push(function(val) {
        return parseInt(val, 10);
      });
      ngModel.$formatters.push(function(val) {
        return '' + val;
      });
    }
  };
})

.controller("EmployeeNew",  ['$scope', '$routeParams', 'Employees', '$location', '$http', function ($scope, $routeParams, Employees, $location, $http) {
  $scope.employee = {skills: []}

  $scope.save = function() {
    $scope.errors = [];

    $scope.employee.skills_list = $scope.employee.skills.map(function(s){ return s.title}).join(", ")

    Employees.create({ employee: $scope.employee }).$promise.then(function(data) {
      $location.url("employees/" + data.id)
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
