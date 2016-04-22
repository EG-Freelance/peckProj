class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  respond_to :html
  
  def add_to_cart
    CartProduct.where(cart_id: Cart.find_by(user_id: current_user.id).id, registry_id: params[:cart_product][:registry_id], product_id: params[:cart_product][:product_id], quantity: params[:cart_product][:quantity] ).first_or_create!
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
  end

  def checkout
    # Set registries being checked out
    r = params['checkout'].map{ |k,v| k unless v == "false" }
    @cp_array = []
    
    # For each registry, send each CartProduct into an array for processing
    r.each do |reg|
      CartProduct.where(cart_id: Cart.find_by(user_id: current_user.id), registry_id: r).each do |p|
        @cp_array << p.product
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
  end
  
  def index
    @carts = Cart.all
    respond_with(@carts)
  end

  def show
    respond_with(@cart)
  end

  def new
    @cart = Cart.new
    respond_with(@cart)
  end

  def edit
  end

  def create
    @cart = Cart.new(cart_params)
    @cart.save
    respond_with(@cart)
  end

  def update
    @cart.update(cart_params)
    respond_with(@cart)
  end

  def destroy
    @cart.destroy
    respond_with(@cart)
  end

  private
    def set_cart
      @cart = Cart.find(params[:id])
    end

    def cart_params
      params[:cart]
    end
end
