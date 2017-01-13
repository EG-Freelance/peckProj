class RegistriesController < ApplicationController
  require 'open-uri'
  before_action :set_registry, only: [:show, :edit, :update, :destroy, :search]
  before_action :set_registries, only: [:index, :add_remove_as_guest, :search_reg]
  after_action :set_registries, only: [:create]

  respond_to :html

  def index
    if params[:q]
      unless params[:q][:user_registries_user_email_cont].blank?
        params[:q][:user_registries_association_type_eq] = "owner"
      end
    end
    @q = Registry.where(private: false).ransack(params[:q])
    @registries = @q.result.uniq.paginate(page: params[:page], per_page: 20)
    
    @registry = Registry.new
  end  
  
  def show
    @products = Product.includes(:product_registries).where(:product_registries => { :registry_id => params['id'] })
    # begin 
    #   ur = UserRegistry.find_by(registry_id: @registry.id, user_id: current_user.id)
    #   if (ur.association_type == "owner" || ur.association_type == "administrator")
    #     products_pool = Product.all
    #   else
    #     products_pool = Product.includes(:product_registries).where(:product_registries => { registry_id: @registry.id })
    #   end
    # rescue
    #   products_pool = Product.includes(:product_registries).where(:product_registries => { registry_id: @registry.id })
    # end

    ###### SET TINY-URL FOR REGISTRY ######    
    # This will change for live site!!
    base = "http://regisli-staging.herokuapp.com"
    path = request.env['PATH_INFO']
    @tiny_url = open('http://tinyurl.com/api-create.php?url=' + base + path, "UserAgent" => "Ruby Script").read
    ########################################
    
    # @q = products_pool.ransack(params[:q])
    # params[:id] = @registry.id
    # @q.sorts = 'name asc' if @q.sorts.empty?
    # @products = @q.result.paginate(page: params[:page], per_page: 24)
  end
  
  def search  
    show
    render :show
  end
  
  def search_reg
    index
    render :index
  end
  
  def add_remove_as_guest
    ur_params = { :user_id => current_user.id, :registry_id => params[:id], :association_type => 'guest' }
    @ur_r = params[:id]
    if UserRegistry.exists?(ur_params)
      UserRegistry.find_by(ur_params).destroy
      @ur_status = "removed"
    else
      UserRegistry.create(ur_params)
      @ur_status = "added"
    end
    if params[:origin_path] == "show_registry"
      render :template => 'registries/add_remove_as_guest_show'
    else
      render :template => 'registries/add_remove_as_guest'
    end
  end
  
  def add_remove_product
    if params['product_registry']['rendering_controller'] == 'registries'
      @product = Product.find(params['product_registry']['product_id'])
    else
      p = eval(params['product_registry']['product_hash'])
      @product = Product.where(
        brand_id: Brand.find_by(popshops_index: p['brand'].to_s).id, 
        popshops_index: p['id'].to_s,
        category: p['category'].to_s,
        name: p['name'],
        description: p['description'],
        popshops_brand: p['brand'].to_s,
        price_min: p['price_min'],
        price_max: p['price_max'],
        offer_count: p['offer_count'],
        image_url: p['image_url_large']
      ).first_or_initialize
    end
    
    if Product.exists?(@product)
      @product.destroy
      @status = "success"
      respond_to do |format|
        format.html { redirect_to :back, notice: "Product removed" }
        format.js { }
      end
    else
      @product.save
      pr = ProductRegistry.where(
        product_id: @product.id, 
        registry_id: params['product_registry']['registry_id'], 
        quantity: params['product_registry']['quantity'],
        purchased: 0
      ).first_or_initialize
      if pr.save
        p['offers']['offer'].each do |o|
          merchant = Merchant.find_by(popshops_index: o['merchant'].to_s )
          offer = Offer.where(
            product_id: @product.id,
            popshops_index: o['id'].to_s,
            sku: o['sku'].to_s,
            popshops_merchant: o['merchant'].to_s,
            name: o['name'],
            description: o['description'],
            url: o['url'],
            image_url_large: o['image_url_large'],
            currency_iso: o['currency_iso'],
            price_merchant: o['price_merchant'],
            price_retail: o['price_retail'],
            estimated_price_total: o['estimated_price_total'],
            condition: o['condition']).first_or_create
          @product.merchants << merchant unless @product.merchants.include?(merchant)
          merchant.offers << offer unless merchant.offers.include?(offer) 
        end
        @status = "success"
        respond_to do |format|
          format.html { redirect_to :back, notice: "Product added" }
          format.js { }
        end
      else
        @status = "failure"
        respond_to do |format|
          format.html { redirect_to :back, alert: "Please be sure to select a quantity" }
          format.js { }
        end
      end
    end
  end
  
  def old_add_remove_product
    @registry = Registry.find(params[:product_registry][:registry_id])
    @product = Product.find(params[:product_registry][:product_id])
    pr_params = { product_id: params[:product_registry][:product_id], registry_id: params[:product_registry][:registry_id] }
    if ProductRegistry.exists?(pr_params)
      pr = ProductRegistry.find_by(pr_params)
      CartProduct.where(pr_params).destroy_all
      pr.destroy
      @status = "success"
      respond_to do |format|
        format.html { redirect_to :back, notice: "Product removed" }
        format.js { }
      end
    else
      pr_params[:quantity] = params[:product_registry][:quantity]
      pr = ProductRegistry.new(pr_params)
      if pr.save
        @status = "success"
        respond_to do |format|
          format.html { redirect_to :back, notice: "Product added" }
          format.js { }
        end
      else
        @status = "failure"
        respond_to do |format|
          format.html { redirect_to :back, alert: "Please be sure to select a quantity" }
          format.js { }
        end
      end
    end
  end
  
  def nonuser_checkout
    @product = Product.find(params[:product_id])
    @registry_id = params[:registry_id]
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
    #render :template => 'registries/nonuser_checkout'
  end
  
  def nonuser_checkout_confirmation
    if params[:nonuser_checkout_confirmation][:quantity].to_i > 0
      @status = "success"
      @product = Product.find(params[:nonuser_checkout_confirmation][:product_id])
      @registry = Registry.find(params[:nonuser_checkout_confirmation][:registry_id])
      pr = ProductRegistry.find_by(registry_id: params[:nonuser_checkout_confirmation][:registry_id], product_id: params[:nonuser_checkout_confirmation][:product_id])
      pr_purch = pr.purchased
      pr.update(purchased: pr_purch + params[:nonuser_checkout_confirmation][:quantity].to_i)
    else
      @status = "failure"
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
  end

  def new
    @registry = Registry.new
    respond_with(@registry)
  end

  def edit
  end

  def create
    @registry = Registry.new(registry_params)
    payment_method = PaymentMethod.find_by(custom_name: params[:registry][:user_registry][:payment_method])
    if payment_method.nil?
      render :template => "registries/registry_create_error"
      return false
    end
    @registry.payment_method_id = payment_method.id
    respond_to do |format|
      if @registry.save
        set_registries
        UserRegistry.create(registry_id: @registry.id, user_id: current_user.id, association_type: 'owner')
        format.html { redirect_to registries_url, notice: "Registry created" }
        format.js { }
      end
    end
    # respond_with(@registry)
  end

  def update
    @registry.update(registry_params)
    respond_with(@registry)
  end

  def destroy
    @registry.destroy
    respond_with(@registry)
  end

  private
    def set_registries
      if user_signed_in?
        @owner = current_user.owned_registries
        @administrator = current_user.shared_registries
        @guest = current_user.guest_registries
      else
        @owner = []
        @administrator = []
        @guest = []
      end
    end
  
    def set_registry
      @registry = Registry.find(params[:id])
    end

    def registry_params
      params.require(:registry).permit(:private, :name, :active, :payment_method_id, :goal, user_registries_attributes: [:preference, :account, :user_id, :registry_id, :association_type])
    end
end