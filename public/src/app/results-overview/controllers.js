'use strict';

angular.module('resultsOverviewControllers', ['ngResource', 'resultsOverviewServices', 'resultsOverviewDirectives'])
    .controller('TestResultCtrl', ['$scope', '$resource', function ($scope, $resource) {

    //This is async and will return a promise which will eventually be populated.
    //This needs to be able to select the correct repository
    $scope.repodata = null;

    //Better to use promise and the data binding to let ui update automatically
    $scope.init = function(value) {
      $scope.repoUrl = value;
      $scope.repodata = $resource($scope.repoUrl).query();
    }

    $scope.isTrendGood = function(endpointdata) {
      var samples = endpointdata.builds;
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
        else {
          output = Math.round(residual) + " seconds ago";
        }
      }
      return output;
    };

    $scope.getPercentComplete = function(doneCount){
      return (doneCount/$scope.urlcount) * 100;
    };

  }])
  .controller('BuildStatusCtrl', ['$scope', '$resource', '$timeout', 'Repository', function ($scope, $resource, $timeout, Repository) {

    $scope.ongoingUrl = null;
    $scope.repoId = null;
    $scope.builddataquery = null;

    $scope.builddata = null;
    $scope.build_percent = null;
    $scope.build_status = null;
    $scope.show_status = false;

    //Better to use promise and the data binding to let ui update automatically
    $scope.init = function(endpoint, repoId) {
      $scope.ongoingUrl = endpoint;
      $scope.repoId = repoId;
      $scope.builddataquery = $resource($scope.ongoingUrl);
      poll();
    }

    $scope.buildLatest = function(repoId) {
      Repository.buildLatest({id: repoId});
    }

    $scope.getPercentComplete = function(doneCount){
      return (doneCount/$scope.urlcount) * 100;
    };

    var poll = function() {
      $timeout(function() {
        //Ugly and has to be a better way to deal with async promise binding to other vars
        $scope.builddata = $scope.builddataquery.query(function() {
          var filtereddata = $scope.builddata.filter(function(val) {
                                  return val.repository_id == $scope.repoId;
                                });
          //Get the last build status out
          var data = filtereddata[filtereddata.length -1];
            if( data )
            {
              if($scope.show_status == false){
                $scope.show_status = true;
              }
              $scope.build_status = data.status_message;
              $scope.build_percent = data.percent_done;
            }
            else
            { //Handle the error case
              if($scope.show_status == true){
                $scope.show_status = false;
                location.reload(true);
              }
            }
          })
        poll();
      }, 1000);
    };
  }]);