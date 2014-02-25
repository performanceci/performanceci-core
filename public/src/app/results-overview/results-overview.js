'use strict';

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

  		$scope.isTrendGood = function(endpointdata) {
  			var samples = endpointdata.builds;
  			//alert("samples: " + samples.length );
  			if(samples.length > 1)
  			{
  				return (samples[samples.length-1].response_time <= samples[samples.length-2].response_time);
  			}
  			else
  			{
  				return true;
  			}
  		}

  		$scope.lastBuildMin = function(endpointdata) {
  			var samples = endpointdata.builds;
  			var output = "";
  			//alert("samples: " + samples.length );
  			if(samples.length > 0){

  				var now = new Date();
  				var lastSample = new Date(samples[samples.length-1].created_at);
				var diff = now - lastSample;

				var residual = diff/1000;
				if(residual > 60){ 
					//Min
					residual = residual/60;
					if(residual > 60){
						//Hours
						residual = residual/60;
						if(residual > 24){
							residual = residual/24;
							output = Math.round(residual) + " days ago";
						}
						else{
							output = Math.round(residual) + " hrs ago";
						}

					}
					else{
						output = Math.round(residual) + " min ago";
					}
				}
				else{
					output = Math.round(residual) + " seconds ago";
				}
  			}
  			
  			return output;
  		};

		$scope.getPercentComplete = function(doneCount){
			return (doneCount/$scope.urlcount) * 100;
		};

	}])
	.controller('BuildStatusCtrl', ['$scope', '$resource', '$timeout', function ($scope, $resource, $timeout) {

		$scope.ongoingUrl = null;
		$scope.repoId = null;
		$scope.builddataquery = null;

		$scope.builddata = null;
		$scope.build_percent = null;
		$scope.build_status = null;
		$scope.show_status = false;

		//$scope.repodata = Repo.query();

		//$scope.urlcount = 2;
		//Repo.query({}, function(tests){
		//	$scope.urlcount = tests.length;
			//alert('Hello');
    	//});

    	//Better to use promise and the data binding to let ui update automatically
    	//$scope.urlcount = Repo.query();
    	$scope.init = function(endpoint, repoId) {
    		$scope.ongoingUrl = endpoint;
    		$scope.repoId = repoId;
    		$scope.builddataquery = $resource($scope.ongoingUrl);
    		poll();
  		}
  		
		$scope.getPercentComplete = function(doneCount){
			return (doneCount/$scope.urlcount) * 100;
		};

    	var poll = function() {
        	$timeout(function() {
        				//Ugly and has to be a better way to deal with async promise binding to other vars
		            	$scope.builddata = $scope.builddataquery.query(function() {
												// server returns: [ {id:456, number:'1234', name:'Smith'} ];
												// NOTE: This needs to check the repository id and us that to filter
												var filtereddata = $scope.builddata.filter(function(val) {
																								return val.repository_id == $scope.repoId;
																							});
												//Get the last build status out
												var data = filtereddata[filtereddata.length -1];
												// each item is an instance of CreditCard
												//expect(card instanceof CreditCard).toEqual(true);
												//card.name = "J. Smith";);
			            						if( data )
			            						{	
			            							if($scope.show_status == false){
			            								$scope.show_status = true;
			            							}
			            							$scope.build_status = data.status_message;
			            							$scope.build_percent = data.percent_done;
			            						}
			            						else
			            						{	//Handle the error case
			            							if($scope.show_status == true){
			            								$scope.show_status = false;
			            								location.reload(true);
			            							}
			            							//$scope.build_status = "Complete"
			            						}
		            						})
		            	poll();
		        	 }, 1000);
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
				        //xLabelFormat: function (x) { return x.toString(); },
				        yLabelFormat: function (y) { return y.toString(); },
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
 					//$('svg').height(500);
	            };

	            attrs.$observe('data',setData); //lets just observe only the data because it is bad to use many observers, anyway this won't work without supplied data
	        }
	    };
	});
