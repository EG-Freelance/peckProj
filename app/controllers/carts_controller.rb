class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  respond_to :html
  
  def add_to_cart
    c = CartProduct.find_or_initialize_by(cart_id: Cart.find_by(user_id: current_user.id).id, registry_id: params[:cart_product][:registry_id], product_id: params[:cart_product][:product_id])
    unless c.quantity == params[:cart_product][:quantity]
      c.quantity = params[:cart_product][:quantity]
      c.save
    end
    @r = current_user.cart.cart_products.map{ |cp| cp.registry_id }.uniq
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
  end

  def checkout
    # Set registries being checked out
    @r = params['checkout'].map{ |k,v| k unless v == "false" }
    @r.delete_if { |r| r.nil? }
    @cp_array = []
    
    # For each registry, send each CartProduct into an array for processing
    @r.each do |reg|
      CartProduct.where(cart_id: Cart.find_by(user_id: current_user.id), registry_id: reg).each do |p|
        @cp_array << p.product
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { 
        render :template => 'carts/checkout'
      }
    end
  end
  
  def checkout_confirmation
    products = params['checkout_confirmation'].map{ |k,v| [k,v] unless v == "0" }
    products.delete_if { |p| p.nil? }
    pairs = products.each_slice(2).to_a
    puts pairs.inspect
    puts CartProduct.find(pairs[0][0][0])
    pairs.each do |p|
      cp = CartProduct.find(p[0][0])
      cp_pr = cp.registry.product_registries.find_by(product_id: cp.product_id)
      cp_quant = cp_pr.quantity
      cp_pr.update(purchased: (p[1][1].to_i + cp_quant))
      cp.destroy      
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
