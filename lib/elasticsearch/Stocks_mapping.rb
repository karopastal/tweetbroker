#index => markit_stocks
#doc -> Lookto
#doc -> ActiveChart
require 'elasticsearch'

doc_interactive_chart = "stock_activity"
doc_lookup = "stock_lookup"

client = Elasticsearch::Client.new host: 'karopastal.com:9200'

index = 'markit_stocks_ohlc'

 client.indices.delete index: index


client.indices.create index: index,
					  body: {
					  	"mappings" => {
					  		doc_interactive_chart => {
					  			"properties" => {
									"symbol" =>  {"type" => "string","index" => "not_analyzed"},
									"currency" => {"type" => "string","index" => "not_analyzed"},
									"type" => {"type" => "string","index" => "not_analyzed"},
								    "position" => {"type" => "double","index" => "not_analyzed"},
								    "open" => {"type" => "double","index" => "not_analyzed"},
								    "high" => {"type" => "double","index" => "not_analyzed"},
								    "low" => {"type" => "double","index" => "not_analyzed"},
								    "close" => {"type" => "double","index" => "not_analyzed"},
								    "markit_Date" => {"type" => "date", "format" => "yyyy-MM-dd HH:mm:ss"}
					  			}
					  		}

					  	},
					  	"settings" => {
							"analysis" => {
							"filter" => {
								"ngram_title" => {
									"type" => "nGram",
									"min_gram" => 2,
									"max_gram" => 50
									},
								"ngram_front" => {
									"type" => "edgeNGram",
									"min_gram" => 2,
									"max_gram" => 50
									}
								},
							"analyzer" => {
								"title_analyzer" => {
									"tokenizer" => "standard",
									"filter" =>["lowercase", "stop","ngram_title","ngram_front"],
									"type" => "custom"
									}
								}
							}
						}
					}


# client.indices.put_mapping index: index, type: doc_lookup,
# 					  body: {
# 					  		doc_lookup => {
# 					  			"properties" => {
					  				
# 									"symbol" =>  {"type" => "string","index" => "not_analyzed"},
# 									"name" => {"type" => "string",
# 										       "index_analyzer" => "title_analyzer",
# 										       "search_analyzer" => "standard"
# 										    },
# 									"exchange" => {"type" => "string",
# 												   "index_analyzer" => "title_analyzer",
# 												   "search_analyzer" => "standard"
# 												}
# 					  			}
# 					  		}
# 					  	}

					  	
client.indices.refresh index: index