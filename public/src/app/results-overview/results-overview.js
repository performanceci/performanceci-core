angular.module('results-overview', ['ngResource'])
	.factory('Repo', ['$resource', function ($resource) {
      //var Repositories = $resource('http://localhost:3000/repositories/1/summary.json:id', {
      //  apiKey:'4fb51e55e4b02e56a67b0b66',
      //  id:'@_id.$oid'
      //});
    	var Repo = $resource('http://127.0.0.1:3000/repositories/5/summary.json');

      	//Repo.prototype.endpointCount = function() {
        //	return 3;
      	//};

      	return Repo;
    }])
    .controller('TestResultCtrl', ['$scope', 'Repo', '$resource', function ($scope, Repo, $resource) {

		//This is async and will return a promise which will eventually be populated.
		//This needs to be able to select the correct repository
		//var repdata = $resource('http://127.0.0.1:3000/repositories/1/summary.json');

		$scope.repodata = null;

		//$scope.repodata = Repo.query();

		//$scope.urlcount = 2;
		//Repo.query({}, function(tests){
		//	$scope.urlcount = tests.length;
			//alert('Hello');
    	//});

    	//Better to use promise and the data binding to let ui update automatically
    	//$scope.urlcount = Repo.query();
    	$scope.init = function(value) {
    		$scope.repoUrl = value;
    		$scope.repodata = $resource($scope.repoUrl).query();
  		}

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
	                xkey = 'index',
	                ykeys= ['response_time'],
	                labels= ['Response Time'];

	            var setData = function(){
	                Morris.Bar({
	                    element: element,
	                    data: data,
	                    xkey: xkey,
	                    ykeys: ykeys,
	                    labels: labels,
	                    parseTime: false,
				        hoverCallback: function (index, options, content) {
  							var row = options.data[index];

  							var newcon = "<div class='morris-hover-row-label'>Commit:"+ row.commit + " </div><div class='morris-hover-point' style='color: #0b62a4'>Response Time:" +
  							row.response_time +"</div>";

							return newcon;
							//return content;//"sin(" + row.commit + ") = " + row.compare;

						}
	                })
	                .on('click', function(i, row){
						//window.open();
						window.open(data[i].compare,"_blank","toolbar=yes, scrollbars=yes, resizable=yes, top=50, left=500, width=800, height=600");
 					});
	            };

	            attrs.$observe('data',setData); //lets just observe only the data because it is bad to use many observers, anyway this won't work without supplied data
	        }
	    };
	})
	.directive('linechart', function() {

	    return {

	        // required to make it work as an element
	        restrict: 'E',
	        template: '<div></div>',
	        replace: true,
	        // observe and manipulate the DOM
	        link: function($scope, element, attrs) {

				var data = $scope[attrs.data].builds,
	                xkey = 'index',
	                ykeys= ['response_time'],
	                hideHover= 'auto',
	                resize= true,
	                labels= ['Response Time'];

	            var setData = function(){
	                Morris.Line({
				        element: element,
				        data: data,
				        xkey: xkey,
				        ykeys: ykeys,
				        labels: labels,
				        hideHover: hideHover,
				        resize: resize,
				        parseTime: false,
				        goals: [1, 0.5],
				        goalStrokeWidth: 3,
				        goalLineColors: ["red", "yellow"],
				        hoverCallback: function (index, options, content) {
  							var row = options.data[index];

  							var newcon = "<div class='morris-hover-row-label'>Commit:"+ row.commit + " </div><div class='morris-hover-point' style='color: #0b62a4'>Response Time:" +
  							row.response_time +"</div>";

							return newcon;
							//return content;//"sin(" + row.commit + ") = " + row.compare;

						}
				    })
	                .on('click', function(i, row){
						//window.open();
						window.open(data[i].compare,"_blank","toolbar=yes, scrollbars=yes, resizable=yes, top=50, left=500, width=800, height=600");
 					});
	            };

	            attrs.$observe('data',setData); //lets just observe only the data because it is bad to use many observers, anyway this won't work without supplied data
	        }
	    };
	});
