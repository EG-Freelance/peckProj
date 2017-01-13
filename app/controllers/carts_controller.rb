class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  respond_to :html
  
  def add_to_cart
    @p_id = params[:cart_offer][:product_id]
    @o_id = params[:cart_offer][:offer_id]
    @r = current_user.cart.cart_offers.map{ |co| co.registry_id }.uniq
    co = CartOffer.where(cart_id: Cart.find_by(user_id: current_user.id).id, registry_id: params[:cart_offer][:registry_id], product_id: params[:cart_offer][:product_id]).first_or_initialize
    unless co.quantity == params[:cart_offer][:quantity] && co.offer_id == params[:cart_offer][:offer_id]
      co.quantity = params[:cart_offer][:quantity]
      co.offer_id = params[:cart_offer][:offer_id]
      co.save
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
    
    ########## OLD CODE BEFORE SWITCH TO CART_OFFER ##########
    # @p_id = params[:cart_product][:product_id]
    # c = CartProduct.find_or_initialize_by(cart_id: Cart.find_by(user_id: current_user.id).id, registry_id: params[:cart_product][:registry_id], product_id: params[:cart_product][:product_id])
    # unless c.quantity == params[:cart_product][:quantity]
    #   c.quantity = params[:cart_product][:quantity]
    #   c.save
    # end
    # @r = current_user.cart.cart_products.map{ |cp| cp.registry_id }.uniq
    # respond_to do |format|
    #   format.html { redirect_to :back }
    #   format.js { }
    # end
  end

  def checkout
    # Set products being checked out
    @co = params['checkout'].map{ |k,v| k unless v == "false" }
    @co.delete_if { |r| r.nil? }
    @co_array = @co.map { |coid| CartOffer.find(coid).offer }
    @merchants = @co.map { |coid| CartOffer.find(coid).offer.merchant }.uniq
    @registry = Registry.find_by(id: CartOffer.find(@co.first).registry_id)
    
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
    # pairs array format:
    # [[ <CartProduct.id>, <checked t/f>],[ <CartProduct.id-quantity>, <CartProduct.quantity confirmed>]]
    product_array = pairs.map{ |p| p[0][0] }
    
    # set total confirmed purchases to make sure the form isn't empty
    sum_array = pairs.map{ |p| p[1][1].to_i }
    sum_confirmed = sum_array.sum
    
    if sum_confirmed > 0
      @status = "success"
      #set @registry for js rendering
      @registry = CartOffer.find(pairs[0][0][0]).registry
      co_set = CartOffer.where(id: product_array)
      product_ids = co_set.map{ |co| co.product_id }

      #set @prs for js rendering
      @prs = ProductRegistry.where(product_id: product_ids, registry_id: @registry.id)
      pairs.each do |p|
        co = CartOffer.find(p[0][0])
        co_pr = co.registry.product_registries.find_by(product_id: co.product_id)
        co_purch = co_pr.purchased
        co_pr.update(purchased: (p[1][1].to_i + co_purch))
        co.destroy      
      end
    else
      @status = "failure"
    end      
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end    
  end
  
  def destroy_cart_offer
    @co_id = params[:format]
    CartOffer.destroy(@co_id)
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
