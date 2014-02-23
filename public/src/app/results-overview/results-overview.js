angular.module('results-overview', ['ngResource'])
	.factory('Repo', ['$resource', function ($resource) {
      //var Repositories = $resource('http://localhost:3000/repositories/1/summary.json:id', {
      //  apiKey:'4fb51e55e4b02e56a67b0b66',
      //  id:'@_id.$oid'
      //});
    	var Repo = $resource('http://localhost:3000/results_overview.json');
      	//Repo.prototype.endpointCount = function() {
        //	return 3;
      	//};

      	return Repo;
    }])
    .controller('TestResultCtrl', ['$scope', 'Repo', function ($scope, Repo) {
		//$scope.rooturl = "www.perfy.com";
		//$scope.urlcount = 999999;
		//$scope.urlcount = 2;
		Repo.query({}, function(tests){
			$scope.urlcount = tests.length();
			alert('Hello');
    	});
		//$scope.urlcount = 77777;


		$scope.testurls = [
			{url: "www.perfy.com", parent: "/"},
			{url: "www.perfy.com/test1", parent: "www.perfy.com"},
			{url: "www.perfy.com/test2", parent: "www.perfy.com"},
		];
		$scope.getPercentComplete = function(doneCount){
			return (doneCount/$scope.urlcount) * 100;
		}
	}]);