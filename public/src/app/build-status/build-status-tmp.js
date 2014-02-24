angular.module('results-overview', ['ngResource'])
  .factory('Repositories', function ($resource) {
    var Repositories = $resource('http://localhost:3000/repositories/1/summary.json:id', {
      apiKey:'4fb51e55e4b02e56a67b0b66',
      id:'@_id.$oid'
    });

    Repositories.prototype.getFullName = function() {
      return this.firstName + ' ' + this.lastName;
    };

    return Repositories;
  })
  .controller('ResultsOverviewCtrl', function ($scope, Repositories) {

    $scope.repositories = Repositories.query({}, function(repositories){
      console.log($scope.repositories.length);
    });

    $scope.remove = function (repositories) {
      Repositories['delete']({}, rep);
      //user.$delete();
    };

    $scope.add = function () {
      var rep = new Repository({
        name:'Superhero'
      });
      user.$save();
    };

    $scope.add = function () {
      var user = {
        name:'Superhero'
      };
      Users.save(user);
    };

  });

  .factory('Tests', function ($resource) {
      //var Repositories = $resource('http://localhost:3000/repositories/1/summary.json:id', {
      //  apiKey:'4fb51e55e4b02e56a67b0b66',
      //  id:'@_id.$oid'
      //});
    var Tests = $resource('http://localhost:3000/results_overview.json');

      Tests.prototype.endpointCount = function() {
        return 3;
      };

      return Tests;
    })


  <div id="morris-area-chart-{{endpointdata.endpoint.id}}"></div>