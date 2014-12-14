require 'elasticsearch'
require 'json'

index = "twitter_mahout"
doc = "streaming_tweets"

es_client = Elasticsearch::Client.new host: 'karopastal.com:9200'

		# query = {
		# 	"sort" => [{"markit_Date" =>{"order" => "desc"}}],
		# 	"size" => 99999,
		# 	"from" => 0,
		# 	"query" =>{
		# 			"bool" => {
		# 				"must" => [
		# 					{"range" => {"markit_Date" => {"gte" => q_params["stocks"]["from"] + " 00:00:00","lte" => q_params["stocks"]["to"] + " 00:00:00"}}}
		# 				]
		# 			}
		# 	}
		# }

		query = {"query" =>{
					"bool" => {
						"must" => [
							{"match" => {"source" => '<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>' }}
						]
					}
			},
			"aggs" => {
				"tweets" => { "terms" => { "field" => "text.raw"} } 
			}
		}

		res = es_client.search index: "twitter", type:"streaming_tweets", body: query 

		p res["aggregations"]["tweets"]
