class RegistriesController < ApplicationController
  before_action :set_registry, only: [:show, :edit, :update, :destroy, :search]
  before_action :set_registries, only: [:index, :add_remove_as_guest, :search_reg]

  respond_to :html

  def index
    @q = Registry.all.ransack(params[:q])
    @registries = @q.result.uniq.paginate(page: params[:page], per_page: 20)
    
    @registry = Registry.new
  end

  def show
    unless @registry.nil?
      Rails.cache.write('registry_id', @registry.id)
    else
      Rails.cache.read('registry_id')
    end
    begin 
      @cart = Cart.first_or_create!(user_id: current_user.id, registry_id: @registry.id)
      ur = UserRegistry.find_by(registry_id: @registry.id, user_id: current_user.id)
      if (ur.association_type == "owner" || ur.association_type == "administrator")
        products_pool = Product.all
      else
        products_pool = Product.includes(:product_registries).where(:product_registries => { registry_id: @registry.id })
      end
    rescue
      products_pool = Product.includes(:product_registries).where(:product_registries => { registry_id: @registry.id })
    end
    
    @q = products_pool.ransack(params[:q])
    params[:id] = @registry.id
    @products = @q.result.paginate(page: params[:page], per_page: 24)
    
    # respond_with(@registry)
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
    render :template => 'registries/add_remove_as_guest'
  end
  
  def add_remove_product
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
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
    #render :template => 'registries/nonuser_checkout'
  end
  
  def nonuser_checkout_confirmation
    
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
      params.require(:registry).permit(:name, :active, :payment_method_id, :goal, user_registries_attributes: [:preference, :account, :user_id, :registry_id, :association_type])
    end
end