class Product < ActiveRecord::Base
  belongs_to :brand
  has_many :offers, dependent: :destroy
  has_many :product_registries, dependent: :destroy
  has_many :merchant_products, dependent: :destroy
  has_many :merchants, :through => :merchant_products
  has_many :registries, :through => :product_registries
  #has_many :cart_products, dependent: :destroy
  #has_many :carts, through: :cart_products
  has_many :cart_offers, :through => :offers

  def self.update_listings
    # set initial page to 1
    i = 1
    loop do
      # Make ID-pull for each 100-product page of results
      popshops = Curl.get("http://api.popshops.com/v3/products.json?account=bmx5dx3qgect9tbrw0zsmvsnx&catalog=cxp18qi882gbqwhz4i4yc2skp&results_per_page=100&page=#{i}")
      results = JSON.parse(popshops.body)
      products = results['results']['products']['product']
      ids = products.map { |r| r['id'] }

      # Use IDs above to pull in specific offer information for each page
      product_offers = Curl.get("http://api.popshops.com/v3/products.json?account=bmx5dx3qgect9tbrw0zsmvsnx&catalog=cxp18qi882gbqwhz4i4yc2skp&results_per_page=100&product=#{ids.join(',')}")
      products_with_offers = JSON.parse(product_offers.body)['results']['products']['product']

      #Create products
      products_with_offers.each do |p|
        product = Product.where(popshops_index: p['id']).first_or_create(category: p['category'], name: p['name'], description: p['description'], popshops_brand: p['brand'], price_min: p['price_min'], price_max: p['price_max'], offer_count: p['offers']['count'], image_url: p['image_url_large'])
        product.touch

        # Create offers for each product
        p['offers']['offer'].each do |o|
          offer = Offer.where(merchant_id: Merchant.find_by(popshops_index: o['merchant']).id, product_id: product.id, popshops_index: o['id'], sku: o['sku'], popshops_merchant: o['merchant'], name: o['name'], description: o['description'], url: o['url'], image_url_large: o['image_url_large'], currency_iso: o['currency_iso'], price_merchant: o['price_merchant'], price_retail: o['price_retail'], estimated_price_total: o['estimated_price_total'], condition: o['condition']).first_or_create
          offer.touch
        end
      end

      # Use original results to pull brands
      brands_hash = results['resources']['brands']['brand']

      # Create brands
      brands_hash.each do |b|
        brand = Brand.where(popshops_index: b['id']).first_or_create(name: b['name'], count: b['count'])
        brand.touch
      end

      break if (results['results']['products']['count']/100.0).ceil == i
      i += 1
    end
  end
end