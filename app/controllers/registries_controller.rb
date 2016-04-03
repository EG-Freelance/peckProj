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
    respond_with(@registry)
  end
  
  def add_remove_product
    @registry = Registry.find(params[:product_registry][:registry_id])
    @product = Product.find(params[:product_registry][:product_id])
    pr_params = { product_id: params[:product_registry][:product_id], registry_id: params[:product_registry][:registry_id] }
    puts '=============='
    puts ProductRegistry.exists?(pr_params)
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
      params.require(:registry).permit(:name, :active)
    end
end
