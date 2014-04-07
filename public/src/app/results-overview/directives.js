'use strict';

angular.module('resultsOverviewDirectives', ['ngResource'])
  .directive('barchart', function() {

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
                }
              })
              .on('click', function(i, row){
                window.open(data[i].compare,"_blank","toolbar=yes, scrollbars=yes, resizable=yes, top=50, left=500, width=800, height=600");
              });
          };
          //lets just observe only the data because it is bad to use many observers, anyway this won't work without supplied data
          attrs.$observe('data',setData);
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
                  labels= ['Response Time'],
                  goals = [],
                  goalLineColors = [];

          var maxResponseTime = $scope[attrs.data].max_response_time;
          var targetResponseTime = $scope[attrs.data].target_response_time;
          if(maxResponseTime)
          {
            goals = [maxResponseTime, targetResponseTime];
            goalLineColors = ["red", "yellow"];
          }

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
              yLabelFormat: function (y) { return y.toString(); },
              goals: goals,
              goalStrokeWidth: 3,
              goalLineColors: goalLineColors,
              hoverCallback: function (index, options, content) {
              var row = options.data[index];

              var newcon = "<div class='morris-hover-row-label'>Commit:"+ row.commit + " </div><div class='morris-hover-point' style='color: #0b62a4'>Response Time:" +
              row.response_time +"</div>";
              return newcon;
            }
          })
          .on('click', function(i, row){
            window.open(data[i].compare,"_blank","toolbar=yes, scrollbars=yes, resizable=yes, top=50, left=500, width=800, height=600");
          });
        };
        attrs.$observe('data',setData); //lets just observe only the data because it is bad to use many observers, anyway this won't work without supplied data
      }
    };
  });
