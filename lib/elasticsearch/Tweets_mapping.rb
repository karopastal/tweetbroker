
require 'elasticsearch'
require 'json'

index = "twitter_mahout"
doc = "streaming_tweets"

es_client = Elasticsearch::Client.new host: 'karopastal.com:9200'

mapping = {
    "mappings" => {
        doc => {
            "properties" => {
                "created_at" => {
                    "type" => "date",
                    "format" => "yyyy-MM-dd HH:mm:ss"
                },
                "id" => {
                    "type" => "long",
                    "index" => "not_analyzed"
                },
                "id_str" => {
                    "type" => "string",
                    "index" => "not_analyzed"
                },
                "text" => {
                    "type" => "string",
                    "fields" => {
                        "raw" => {
                            "type" => "string",
                            "index" => "not_analyzed"
                        },
                        "analyzed" => {
                            "type" => "string",
                            "search_analyzer" => "standard",
                            "index_analyzer" => "title_analyzer"
                        }
                    }
                },
                "source" => {
                    "type" => "string",
                    "index" => "not_analyzed"
                },
                "user" => {
                    "properties" => {
                        "id" => {
                            "type" => "long",
                            "index" => "not_analyzed"
                        },
                        "id_str" => {
                            "type" => "string",
                            "index" => "not_analyzed"
                        },
                        "name" => {
                            "type" => "string",
                            "fields" => {
                                "raw" => {
                                    "type" => "string",
                                    "index" => "not_analyzed"
                                },
                                "analyzed" => {
                                    "type" => "string",
                                    "search_analyzer" => "standard",
                                    "index_analyzer" => "title_analyzer"
                                }
                            }
                        },
                        "followers_count" => {
                            "type" => "long",
                            "index" => "not_analyzed"
                        },
                        "friends_count" => {
                            "type" => "long",
                            "index" => "not_analyzed"
                        },
                        "profile_image_url" => {
                            "type" => "string",
                            "index" => "not_analyzed"
                        }
                    }
                    },
                    "geo" => {
                        "type" => "double",
                        "index" => "not_analyzed"
                    },
                    "coordinates" => {
                        "type" => "geo_point"
                    },
                    "place" => {
                        "properties" => {
                            "id" => {
                                "type" => "string",
                                "index" => "not_analyzed"
                            },
                            "url" => {
                                "type" => "string",
                                "index" => "not_analyzed"
                            },
                            "full_name" => {
                                "type" => "string",
                                "fields" => {
                                    "raw" => {
                                        "type" => "string",
                                        "index" => "not_analyzed"
                                    },
                                    "analyzed" => {
                                        "type" => "string",
                                        "search_analyzer" => "standard",
                                        "index_analyzer" => "title_analyzer"
                                    }
                                }
                            },
                            "country_code" => {
                                "type" => "string",
                                "index" => "not_analyzed"
                            },
                            "country" => {
                                "type" => "string",
                                "fields" => {
                                    "raw" => {
                                        "type" => "string",
                                        "index" => "not_analyzed"
                                    },
                                    "analyzed" => {
                                        "type" => "string",
                                        "search_analyzer" => "standard",
                                        "index_analyzer" => "title_analyzer"
                                    }
                                }
                            },
                            "bounding_box" => {
                                "type" => "geo_shape"
                            }
                        }
                    }
                }
            }
        },
        "settings" => {
            "number_of_shards" => 1,
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
                        "filter" => [
                            "lowercase",
                            "stop",
                            "ngram_title",
                            "ngram_front"
                        ],
                        "type" => "custom"
                    }
                }
            }
        }
  }

# es_client.indices.delete index: index
# es_client.indices.create index: index, body: mapping

tweet_lst = []
tweet_lst = [
      '{"created_at":"Sat Aug 23 17:27:15 +0000 2014","id":503232011784298496,"id_str":"503232011784298496","text":"In all seriousness I think a kick back with your closest pals is way more fun than an actual party","source":"\u003Ca href=\"http://twitter.com/download/iphone\" rel=\"nofollow\"\u003ETwitter for iPhone\u003C/a\u003E","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":417412637,"id_str":"417412637","name":"","screen_name":"holly_walle","location":"","url":null,"description":"In poison places we are anti-venom","protected":false,"verified":false,"followers_count":609,"friends_count":206,"listed_count":0,"favourites_count":5698,"statuses_count":17522,"created_at":"Sun Nov 20 22:19:21 +0000 2011","utc_offset":-25200,"time_zone":"Arizona","geo_enabled":true,"lang":"en","contributors_enabled":false,"is_translator":false,"profile_background_color":"0F0E0E","profile_background_image_url":"http://pbs.twimg.com/profile_background_images/856907804/3e146d8d404dd2c373fcd201d6db0240.jpeg","profile_background_image_url_https":"https://pbs.twimg.com/profile_background_images/856907804/3e146d8d404dd2c373fcd201d6db0240.jpeg","profile_background_tile":true,"profile_link_color":"D02B55","profile_sidebar_border_color":"000000","profile_sidebar_fill_color":"99CC33","profile_text_color":"3E4415","profile_use_background_image":true,"profile_image_url":"http://pbs.twimg.com/profile_images/502275220733165568/dJnG0Bc__normal.jpeg","profile_image_url_https":"https://pbs.twimg.com/profile_images/502275220733165568/dJnG0Bc__normal.jpeg","profile_banner_url":"https://pbs.twimg.com/profile_banners/417412637/1407784373","default_profile":false,"default_profile_image":false,"following":null,"follow_request_sent":null,"notifications":null},"geo":{"type":"Point","coordinates":[37.164816,-119.799833]},"coordinates":{"type":"Point","coordinates":[-119.799833,37.164816]},"place":{"id":"fbd6d2f5a4e4a15e","url":"https://api.twitter.com/1.1/geo/id/fbd6d2f5a4e4a15e.json","place_type":"admin","name":"California","full_name":"California, USA","country_code":"US","country":"United States","bounding_box":{"type":"Polygon","coordinates":[[[-124.482003,32.528832],[-124.482003,42.009519],[-114.131212,42.009519],[-114.131212,32.528832]]]},"attributes":{}},"contributors":null,"retweet_count":0,"favorite_count":0,"entities":{"hashtags":[],"trends":[],"urls":[],"user_mentions":[],"symbols":[]},"favorited":false,"retweeted":false,"possibly_sensitive":false,"filter_level":"medium","lang":"en"}',
      '{"created_at":"Sat Aug 23 17:27:19 +0000 2014","id":503232026174955520,"id_str":"503232026174955520","text":"Campinggg","source":"\u003Ca href=\"http://twitter.com/download/android\" rel=\"nofollow\"\u003ETwitter for Android\u003C/a\u003E","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":715899613,"id_str":"715899613","name":"Ventura Martin ®","screen_name":"VenturaM99","location":"San Fernando","url":null,"description":"Instagram: venturamartiiin","protected":false,"verified":false,"followers_count":400,"friends_count":228,"listed_count":0,"favourites_count":163,"statuses_count":6170,"created_at":"Wed Jul 25 11:10:39 +0000 2012","utc_offset":7200,"time_zone":"Amsterdam","geo_enabled":true,"lang":"es","contributors_enabled":false,"is_translator":false,"profile_background_color":"C0DEED","profile_background_image_url":"http://abs.twimg.com/images/themes/theme1/bg.png","profile_background_image_url_https":"https://abs.twimg.com/images/themes/theme1/bg.png","profile_background_tile":false,"profile_link_color":"0084B4","profile_sidebar_border_color":"C0DEED","profile_sidebar_fill_color":"DDEEF6","profile_text_color":"333333","profile_use_background_image":true,"profile_image_url":"http://pbs.twimg.com/profile_images/494846170179858432/UXSOoHiZ_normal.jpeg","profile_image_url_https":"https://pbs.twimg.com/profile_images/494846170179858432/UXSOoHiZ_normal.jpeg","profile_banner_url":"https://pbs.twimg.com/profile_banners/715899613/1385815766","default_profile":true,"default_profile_image":false,"following":null,"follow_request_sent":null,"notifications":null},"geo":{"type":"Point","coordinates":[35.927433,-119.001077]},"coordinates":{"type":"Point","coordinates":[-119.001077,35.927433]},"place":{"id":"fbd6d2f5a4e4a15e","url":"https://api.twitter.com/1.1/geo/id/fbd6d2f5a4e4a15e.json","place_type":"admin","name":"California","full_name":"California, USA","country_code":"US","country":"United States","bounding_box":{"type":"Polygon","coordinates":[[[-124.482003,32.528832],[-124.482003,42.009519],[-114.131212,42.009519],[-114.131212,32.528832]]]},"attributes":{}},"contributors":null,"retweet_count":0,"favorite_count":0,"entities":{"hashtags":[],"trends":[],"urls":[],"user_mentions":[],"symbols":[]},"favorited":false,"retweeted":false,"possibly_sensitive":false,"filter_level":"medium","lang":"en"}',
      '{"created_at":"Sat Aug 23 17:27:20 +0000 2014","id":503232031522697216,"id_str":"503232031522697216","text":"He said, \"I love her with every breath I breathe \" 😍😍😍","source":"\u003Ca href=\"http://twitter.com/download/iphone\" rel=\"nofollow\"\u003ETwitter for iPhone\u003C/a\u003E","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":188302375,"id_str":"188302375","name":"Nia Alexander","screen_name":"nialuvstheereal","location":"","url":"http://www.facebook.com/nia.alexander","description":null,"protected":false,"verified":false,"followers_count":156,"friends_count":167,"listed_count":1,"favourites_count":265,"statuses_count":22939,"created_at":"Wed Sep 08 12:14:07 +0000 2010","utc_offset":-18000,"time_zone":"Quito","geo_enabled":true,"lang":"en","contributors_enabled":false,"is_translator":false,"profile_background_color":"917157","profile_background_image_url":"http://pbs.twimg.com/profile_background_images/160923012/x5eee39228f60031c3c9410c4b036b0c.png","profile_background_image_url_https":"https://pbs.twimg.com/profile_background_images/160923012/x5eee39228f60031c3c9410c4b036b0c.png","profile_background_tile":true,"profile_link_color":"8F8376","profile_sidebar_border_color":"13081C","profile_sidebar_fill_color":"514052","profile_text_color":"B457FF","profile_use_background_image":true,"profile_image_url":"http://pbs.twimg.com/profile_images/447613631299985408/KCkPSV8v_normal.jpeg","profile_image_url_https":"https://pbs.twimg.com/profile_images/447613631299985408/KCkPSV8v_normal.jpeg","default_profile":false,"default_profile_image":false,"following":null,"follow_request_sent":null,"notifications":null},"geo":{"type":"Point","coordinates":[37.843008,-122.274771]},"coordinates":{"type":"Point","coordinates":[-122.274771,37.843008]},"place":{"id":"ab2f2fac83aa388d","url":"https://api.twitter.com/1.1/geo/id/ab2f2fac83aa388d.json","place_type":"city","name":"Oakland","full_name":"Oakland, CA","country_code":"US","country":"United States","bounding_box":{"type":"Polygon","coordinates":[[[-122.34266,37.699279],[-122.34266,37.8847092],[-122.114711,37.8847092],[-122.114711,37.699279]]]},"attributes":{}},"contributors":null,"retweet_count":0,"favorite_count":0,"entities":{"hashtags":[],"trends":[],"urls":[],"user_mentions":[],"symbols":[]},"favorited":false,"retweeted":false,"possibly_sensitive":false,"filter_level":"medium","lang":"en"}'
]



tweet_lst.each do |tweet|

      json_tweet = JSON.load(tweet)

      data = {}
      user = {} 
      place = {}


      timevar = Time.parse(json_tweet['created_at'])

      # p 'created_at  :  ', timevar.strftime("%Y-%m-%d %H:%M:%S")
      data['created_at'] = timevar.strftime("%Y-%m-%d %H:%M:%S")

      # p 'id  : ', json_tweet['id']
      data['id'] = json_tweet['id']

      # p 'id_str  : ', json_tweet['id_str']
      data['id_str'] = json_tweet['id_str'] 
      # p 'text  :  ', json_tweet['text']
      data['text'] = json_tweet['text']

      # p 'source  :  ',json_tweet['source']
      data['source'] = json_tweet['source']


      # p 'geo  :  ', json_tweet['geo']['coordinates']
      data['geo'] = json_tweet['geo']['coordinates']

      # p 'coordinates  :  ', json_tweet['coordinates']['coordinates']
      data['coordinates'] = json_tweet['coordinates']['coordinates']

      # p 'user id  :  ', json_tweet['user']['id']
      user['id'] = json_tweet['user']['id'] 

      # p 'user id_str  :  ', json_tweet['user']['id_str']  
      user['id_str'] = json_tweet['user']['id_str']  

      # p 'user name  :  ', json_tweet['user']['name']
      user['name'] = json_tweet['user']['name']

      # p 'user followers_count  :  ', json_tweet['user']['followers_count']
      user['followers_count'] = json_tweet['user']['followers_count']

      # p 'user friends_count  :  ', json_tweet['user']['friends_count']
      user['friends_count'] = json_tweet['user']['friends_count']

      # p 'user profile_image_url  :  ', json_tweet['user']['profile_image_url']
      user['profile_image_url'] = json_tweet['user']['profile_image_url']

      data['user'] = user

      # p 'place id  :  ', json_tweet['place']['id']
      place['id'] = json_tweet['place']['id']

      # p 'place url  :  ', json_tweet['place']['url']
      place['url'] = json_tweet['place']['url']

      # p 'place full_name  :  ', json_tweet['place']['full_name']
      place['full_name'] = json_tweet['place']['full_name']

      # p 'place country_code  :  ', json_tweet['place']['country_code']
      place['country_code'] = json_tweet['place']['country_code']

      # p 'place country  :  ', json_tweet['place']['country']
      place['country'] = json_tweet['place']['country']

      coords  = json_tweet['place']['bounding_box']['coordinates']

      coords[0] << json_tweet['place']['bounding_box']['coordinates'][0][0]

      p coords

      place['bounding_box'] = {'type' => 'polygon', 'coordinates' => coords }

      data['place'] = place

      es_client.index index: index, type: doc, body: data

end

# tweet_lst.each do |tweet|
      # json_tweet = JSON.load(tweet)
      
# end



