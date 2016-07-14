module Scraper
  account_key = "bmx5dx3qgect9tbrw0zsmvsnx"
  # catalog_key = "db46yl7pq0tgy9iumgj88bfj7" # <-- all merchants catalog
  catalog_key = "cxp18qi882gbqwhz4i4yc2skp" # <-- Regisli custom catalog
  
  response = Curl.get("http://api.popshops.com/v3/products.json?account=#{account_key}&catalog=#{catalog_key}&results_per_page=100")
  response_hash = JSON.parse(response.body)
  products = response_hash['results']['products']['product']
end