class EsTweetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

	def show	
	end
	    
	def create
	   tweets_query(params[:es_tweet])
	end

	def index(p)
	    # Respond to request with post data in json format
	       respond_with(p) do |format|
	       format.json { render :json => p.as_json }	
	   end
	end
	def tweets_query(q_params)
		
		query = {"query" =>{
					"bool" => {
						"must" => [
							{"match" => {"source" => '<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>' }},
							{"range" => {"created_at" => {"gte" => q_params["tweets"]["from"] + " 00:00:00","lte" => q_params["tweets"]["to"] + " 00:00:00"}}}
						]
					}
			},
			"aggs" => {
				"tweets" => { "terms" => { "field" => "text.raw"} } 
			}
		}

		res = $elasticsearch.search index: "twitter", type:"streaming_tweets", body: query 

		index(res["aggregations"]["tweets"])
	end
end
