angular.module('results-overview', ['ngResource'])
	.factory('Repo', ['$resource', function ($resource) {
      //var Repositories = $resource('http://localhost:3000/repositories/1/summary.json:id', {
      //  apiKey:'4fb51e55e4b02e56a67b0b66',
      //  id:'@_id.$oid'
      //});
    	var Repo = $resource('http://127.0.0.1:3000/repositories/1/summary.json');
      	
      	//Repo.prototype.endpointCount = function() {
        //	return 3;
      	//};

      	return Repo;
    }])
    .controller('TestResultCtrl', ['$scope', 'Repo', function ($scope, Repo) {
		
		//This is async and will return a promise which will eventually be populated.
		$scope.repodata = Repo.query();
		
		//$scope.urlcount = 2;
		Repo.query({}, function(tests){
			$scope.urlcount = tests.length;
			//alert('Hello');
    	});
    	//Better to use promise and the data binding to let ui update automatically
    	//$scope.urlcount = Repo.query();

		$scope.repodata = Repo.query();

		$scope.getPercentComplete = function(doneCount){
			return (doneCount/$scope.urlcount) * 100;
		}
	}]);