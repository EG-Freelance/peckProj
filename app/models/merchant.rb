class Merchant < ActiveRecord::Base
  belongs_to :merchant_type
  has_many :merchant_products
  has_many :products, :through => :merchant_products
  has_many :offers
 
  def self.update_merchants
    # Pull all merchants in catalog'
    # May need to loop if merchant count gets too high
    i = 1
    loop do
      merchants = Curl.get("http://api.popshops.com/v3/merchants.json?account=bmx5dx3qgect9tbrw0zsmvsnx&catalog=cxp18qi882gbqwhz4i4yc2skp&page=#{i+1}")
      merchants = JSON.parse(merchants.body)
      merchants_hash = merchants['results']['merchants']['merchant']
      break if merchants_hash.empty?
      
      # Create merchants
      merchants_hash.each do |m|
        merchant = Merchant.where(popshops_index: m['id'].to_s).first_or_create
        merchant.update(merchant_type_id: MerchantType.find_by(popshops_index: m['merchant_type'].to_s).id, name: m['name'], network: m['network'].to_s, product_count: m['product_count'], deal_count: m['deal_count'], network_merchant_id: m['network_merchant_id'].to_s, popshops_merchant_type: m['merchant_type'].to_s, country: m['country'].to_s, category: m['category'].to_s, logo_url: m['logo_url'], url: m['url'], site_url: m['site_url'])
        # NOTE: Adding: merchant_type: m['merchant_type'] is throwing errors, so removed --- Pretty sure it's superfluous anyway
        merchant.touch
      end
      i += 1
    end
  end
end