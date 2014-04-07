'use strict';

angular.module('resultsOverviewServices', ['ngResource'])
  .factory('Repository', ['$resource',
    function($resource){
      return $resource('repositories/:id.json', {}, {
        buildLatest: { method:'PUT', params:{id:'@id'}, url: 'repositories/:id/build_latest.json', isArray:false }
      });
    }])
  .factory('Repo', ['$resource', function ($resource) {
    var Repo = $resource('/repositories/5/summary.json');
    return Repo;
  }]);