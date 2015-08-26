var JobsService = angular.module('JobsService', ['ngResource']);

JobsService.factory('Jobs', ['$resource',
                    function($resource){
                      return $resource('jobs/:id.json', {id: '@id'}, {
                        'save':   {method:'PUT'},
                      });
                    }]);
