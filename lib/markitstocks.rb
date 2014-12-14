require 'net/http'
require 'json'
require 'elasticsearch'

index = 'markit_stocks_ohlc'
doc_interactive_chart = "stock_activity"
doc_lookup = "stock_lookup"

es_client = Elasticsearch::Client.new host: 'karopastal.com:9200'

stock_q_params = {}
element = {}

element["Symbol"] ="AAPL" 
element["Type"] ="price"
element["Params"] =["ohlc"]


stock_q_params["Normalized"] ="false"
stock_q_params["StartDate"]="2014-04-27T00:00:00-00"
stock_q_params["EndDate"] ="2014-08-27T00:00:00-00"
stock_q_params["DataPeriod"] = "Day"
# stock_q_params["NumberOfDays"] = 365
stock_q_params["Elements"] = [element]
# a["Elements"] << element

params = {:parameters => stock_q_params.to_json}


uri = URI('http://dev.markitondemand.com/Api/v2/InteractiveChart/json')
uri.query = URI.encode_www_form(params)
# puts uri
res = Net::HTTP.get_response(uri)


i = 0
indices = []

res_json = JSON.load(res.body)
currency = res_json['Elements'][0]['Currency']
symbol = res_json['Elements'][0]['Symbol']
type = res_json['Elements'][0]['Type']

res_json['Positions'].each do |position|
	data = {}
	
	data['symbol'] = symbol
	data['currency'] = currency
	data['type'] = type
	data['position'] = position
	data['markit_Date'] = res_json['Dates'][i].gsub("T"," ")
	data['open'] =  res_json['Elements'][0]['DataSeries']['open']['values'][i]
	data['high'] =  res_json['Elements'][0]['DataSeries']['high']['values'][i]
	data['low'] =  res_json['Elements'][0]['DataSeries']['low']['values'][i]
	data['close'] =  res_json['Elements'][0]['DataSeries']['close']['values'][i]
	
	es_client.index index: index, type: doc_interactive_chart, body: data

	# indices << data
	# if indices.length == 1 
	# 	es_client.index index: index, type: doc_interactive_chart, body: indices
	# 	indices = []
	# end

	i = i + 1	
end

puts i

p res_json

# if indices.length > 0

# 	es_client.bulk index: index, type: doc_interactive_chart, body: indices
# 	puts indices
# 	indices = []
# end

es_client.indices.refresh index: index