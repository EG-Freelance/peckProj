class RegistriesController < ApplicationController
  before_action :set_registry, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @owner = current_user.owned_registries
    @administrator = current_user.shared_registries
    @guest = current_user.guest_registries
    @registries = Registry.all
    
    @registry = Registry.new
  end

  def show
    ur = UserRegistry.find_by(registry_id: @registry.id, user_id: current_user.id)
    begin 
      if (ur.association_type == "owner" || ur.association_type == "administrator")
        @products = Product.all
      else
        @products = Product.includes(:product_registries).where(:product_registries => { registry_id: @registry.id })
      end
    rescue
      @products = Product.includes(:product_registries).where(:product_registries => { registry_id: @registry.id })
    end
    respond_with(@registry)
  end
  
  def add_remove_product
    @registry = Registry.find(params[:product_registry][:registry_id])
    @product = Product.find(params[:product_registry][:product_id])
    pr_params = { product_id: params[:product_registry][:product_id], registry_id: params[:product_registry][:registry_id] }
    if ProductRegistry.exists?(pr_params)
      ProductRegistry.find_by(pr_params).destroy
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
    def set_registry
      @registry = Registry.find(params[:id])
    end

    def registry_params
      params.require(:registry).permit(:name, :active, :payment_method_id, :goal, user_registries_attributes: [:preference, :account, :user_id, :registry_id, :association_type])
    end
end
