var EmployeesService = angular.module('EmployeesService', ['ngResource']);

EmployeesService.factory('Employees', ['$resource',
                    function($resource){
                      return $resource('employees/:id.json', {id: '@id'}, {
                        'save':   {method:'PUT'},
                      });
                    }]);
