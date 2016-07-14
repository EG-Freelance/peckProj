class MerchantType < ActiveRecord::Base
  has_many :merchants
  
  def self.update_merchant_types
    # Pull all merchant_types
    merchant_types = Curl.get("http://api.popshops.com/v3/merchant_types.json?account=bmx5dx3qgect9tbrw0zsmvsnx")
    merchant_types = JSON.parse(merchant_types.body)
    merchant_types_hash = merchant_types['results']['merchant_types']['merchant_type']
    
    # Create merchant_type
    merchant_types_hash.each do |m|
      merchant_type = MerchantType.where(popshops_index: m['id']).first_or_create(name: m['name'])
      merchant_type.touch
    end
  end
end
