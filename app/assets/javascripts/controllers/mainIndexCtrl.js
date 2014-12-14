angular.module('appModule.controllers',['appModule.directives'])

.controller('IndexCtrl', ['$scope','$http',function($scope, $http){
	$scope.title = "title";

            google.maps.event.addListener($scope.map, 'click', function(e) {
                $scope.$apply(function() {
                    addMarker({
                    lat: e.latLng.lat(),
                    lng: e.latLng.lng()
                  }); 
                    
                    console.log(e);
                });
    
            }); // end click listener
            
            addMarker = function(pos){
               var myLatlng = new google.maps.LatLng(pos.lat,pos.lng);
               var marker = new google.maps.Marker({
                    position: myLatlng, 
                    map: $scope.map,
                    title:"Hello World!"
                });
            }

    $scope.gochart = function(symbol,stock_from,stock_to){
      
      params = {"stocks" : {"symbol" : symbol, "from" : stock_from, "to" : stock_to }};
      
      

      $http.post("http://karopastal.com:3001/es_query.json", params).success(function(stockData){

      		// console.log(stockData["hits"]["hits"]);

  
      		data = [];

      		for (var i = 0; i < stockData["hits"]["hits"].length; i++) {
      			bar = {};

      			bar['x'] = i +1 ;
      			bar['open'] = stockData["hits"]["hits"][i]['_source']['open'];
      			bar['high'] = stockData["hits"]["hits"][i]['_source']['high']
      			bar['low'] = stockData["hits"]["hits"][i]['_source']['low']
      			bar['close'] = stockData["hits"]["hits"][i]['_source']['close']

      			data.push(bar);
      		};

      		console.log(data.length);

FusionCharts.ready(function () {
    var visitChart = new FusionCharts({
        type: 'candlestick',
        renderAt: 'chart-container',
        id: 'myChart',
        width: '600',
        height: '450',
        dataFormat: 'json',
        dataSource: {
    "chart": {
        "palette": "1",
        "plotpriceas": "Line",
        "numpdivlines": "5",
        "caption": "XYZ - 3 Months",
        "numberprefix": "$",
        "bearbordercolor": "E33C3C",
        "bearfillcolor": "E33C3C",
        "bullbordercolor": "1F3165",
        "pyaxisname": "Price",
        "vyaxisname": "Volume (In Millions)",
        "showBorder": "0"
    },
    "categories": [
        {
            "category": [
                {
                    "label": "2014",
                    "x": "1"
                },
                {
                    "label": "June",
                    "x": "31"
                },
                {
                    "label": "August",
                    "x": "59"
                }
            ]
        }
    ],
    "dataset": [
        {
            "data": data
        }
    ]
}
    });

    visitChart.render();
	});


 });
    
 }


}])

.controller('PostCtrl', ['$scope','$location','$http',function($scope, $location, $http){
	$scope.title = "welcome to singapore";
	$scope.exploreStocks = function(){
		$location.url('/stocks')
	}

	$scope.exploreTweets = function(){
		$location.url('/tweets')
	}


	

}])
.controller('TweetsCtrl', ['$scope','$location','$http',function($scope, $location, $http){

	

	 $scope.gochart = function(symbol,tweets_from,tweets_to){

	 	params = {"tweets" : {"symbol" : symbol, "from" : tweets_from, "to" : tweets_to }};

	     $http.post("http://karopastal.com:3001/es_tweets.json", params).success(function(tweetData){

      	      		// console.log(stockData["hits"]["hits"]);
      		data = [];
      		j = 1
      		for (var i = 0; i < tweetData["buckets"].length; i++) {
      			bar = {};
      			j = j*-1;
      			bar['x'] = i * 10;
      			bar['y'] = tweetData["buckets"][i]['doc_count'] * 10 * j;
      			bar['z'] = tweetData["buckets"][i]['doc_count'];
      			bar['name'] = tweetData["buckets"][i]['key'];

      			data.push(bar);
      		};

      		console.log(data)

FusionCharts.ready(function () {
    var conversionChart = new FusionCharts({
        type: 'bubble',
        renderAt: 'chart-container',
        width: '600',
        height: '300',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                "caption": "Tweets via iPhone users",
                    "subcaption": "Key values tags",
                    "xAxisMinValue": "0",
                    "xAxisMaxValue": "100",
                    "yAxisMinValue": "-100",
                    "yAxisMaxValue": "100",
                    "plotFillAlpha": "70",
                    "plotFillHoverColor": "#6baa01",
                    "showPlotBorder": "0",
                    "xAxisName": "",
                    "yAxisName": "",
                    "numDivlines": "2",
                    "showValues":"1",
                    "showTrendlineLabels": "0",
                    "plotTooltext": "$name :  $zvalue",
                    "theme": "fint"
            },
               "categories": [{
                "category": [{
                    "label": "0",
                        "x": "0"
                }, {
                    "label": "",
                        "x": "20",
                        "showverticalline": "1"
                }, {
                    "label": "$40",
                        "x": "40",
                        "showverticalline": "1"
                }, {
                    "label": "",
                        "x": "60",
                        "showverticalline": "1"
                }, {
                    "label": "",
                        "x": "80",
                        "showverticalline": "1"
                }, {
                    "label": "",
                        "x": "100",
                        "showverticalline": "1"
                }]
            }],
                "dataset": [{
                    "color":"#00aee4",
                "data": data
            }],
                "trendlines": [{
                "line": [{
                    "startValue": "20000",
                        "endValue": "30000",
                        "isTrendZone": "1",
                        "color": "#aaaaaa",
                        "alpha": "14"
                }, {
                    "startValue": "10000",
                        "endValue": "20000",
                        "isTrendZone": "1",
                        "color": "#aaaaaa",
                        "alpha": "7"
                }]
            }]
        }
   		 });
	    conversionChart.render();
			});
      });


			}


	// $scope.gochart();

}]);