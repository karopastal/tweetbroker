class EsQueryController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

	def show	
	end
	    
	def create
	   stock_query(params[:es_query])
	end

	def index(p)
	    # Respond to request with post data in json format
	       respond_with(p) do |format|
	       format.json { render :json => p.as_json }	
	   end
	end


	def stock_query(q_params)
		
		query = {
			"sort" => [{"markit_Date" =>{"order" => "desc"}}],
			"size" => 99999,
			"from" => 0,
			"query" =>{
					"bool" => {
						"must" => [
							{"range" => {"markit_Date" => {"gte" => q_params["stocks"]["from"] + " 00:00:00","lte" => q_params["stocks"]["to"] + " 00:00:00"}}}
						]
					}
			}
		}

		res = $elasticsearch.search index: "markit_stocks_ohlc", type:"stock_activity", body: query 
		index(res)
	end

  
end
