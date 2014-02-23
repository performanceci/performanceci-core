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
		//This needs to be able to select the correct repository
		$scope.repodata = Repo.query();

		//$scope.urlcount = 2;
		//Repo.query({}, function(tests){
		//	$scope.urlcount = tests.length;
			//alert('Hello');
    	//});

    	//Better to use promise and the data binding to let ui update automatically
    	//$scope.urlcount = Repo.query();

		$scope.getPercentComplete = function(doneCount){
			return (doneCount/$scope.urlcount) * 100;
		};

	}])
	.directive('barchart', function() {

	    return {

	        // required to make it work as an element
	        restrict: 'E',
	        template: '<div></div>',
	        replace: true,
	        // observe and manipulate the DOM
	        link: function($scope, element, attrs) {

	            //var data = $scope[attrs.data],
	            //    xkey = $scope[attrs.xkey],
	            //    ykeys= $scope[attrs.ykeys],
	            //    labels= $scope[attrs.labels];

				var data = $scope[attrs.data].builds,
	                xkey = 'commit',
	                ykeys= ['response_time', 'created_at'],
	                labels= attrs.labels;
	            
	            var setData = function(){
	                Morris.Bar({
	                    element: element,
	                    data: data,
	                    xkey: xkey,
	                    ykeys: ykeys,
	                    labels: labels
	                });
	            };

	            attrs.$observe('data',setData); //lets just observe only the data because it is bad to use many observers, anyway this won't work without supplied data
	        }
	    };
	});
