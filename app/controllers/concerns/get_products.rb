module GetProducts
  # Pull products from PopShops API
  def self.get_products(keywords, page)
    
    products = {}
    
    # Make ID-pull for each 100-product page of results
    popshops = Curl.get("http://api.popshops.com/v3/products.json?account=bmx5dx3qgect9tbrw0zsmvsnx&catalog=cxp18qi882gbqwhz4i4yc2skp&results_per_page=100&page=#{page}&keyword=#{keywords}")
    results = JSON.parse(popshops.body)
    p_results = results['results']['products']['product']
    
    if p_results.empty?
      return nil
    end
    
    count = results['results']['products']['count']
    
    # Create products to house offers
#    p_results.each do |p|
#      products[p['name'] = { 'product' => p }
#    end
    
    ids = p_results.map { |r| r['id'] }

    # Use IDs above to pull in specific offer information for each page
    product_offers = Curl.get("http://api.popshops.com/v3/products.json?account=bmx5dx3qgect9tbrw0zsmvsnx&catalog=cxp18qi882gbqwhz4i4yc2skp&results_per_page=100&product=#{ids.join(',')}")
    o_results = JSON.parse(product_offers.body)
    # Make sure brands are stored and maintained
    brands = o_results['resources']['brands']['brand']
    brands.each do |b|
      brand = Brand.find_by(popshops_index: b['id'].to_s)
      if brand == nil
        Brand.create(popshops_index: b['id'].to_s, name: b['name'])
      else
        unless brand.name == b['name']
          brand.update(name: b['name'])
        end
      end
    end
    products_with_offers = o_results['results']['products']['product']

    #Create products with offers (format example: products = {'XBox360' => { 'product' => <<product details>>, 'offers' => [<<offer 1 details>>, <<offer 2 details>>] } } )
    products_with_offers.each do |p|
      products[p['name']] = { 'product' => p, 'offers' => p['offers']['offer'] }
    end
    return [products, count]
  end
end