class ProductsController < ApplicationController
  include GetProducts
  
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_registries, only: [:index, :set_current_reg]

  respond_to :html
  
  def add_to_registry
  end
  
  def set_current_reg
    @registry = Registry.find_by(id: params['reg_select'])
    @keywords = params['current_reg'][:keywords]
    @page = params['current_reg'][:page]
    #@products = GetProducts.get_products(@keywords, @page)
    respond_to do |format|
      format.html { redirect_to action: "index", keywords: @keywords, page: @page, registry: @registry.nil? ? nil : @registry.id }
    end
  end

  def index
    @registry = Registry.find(params[:registry]) unless params[:registry].nil?
    @keywords = params[:keywords]
    @page = params[:page]
    p_summary = GetProducts.get_products(@keywords, @page)
    if p_summary.nil?
      @products = nil
      @product_count = 0
    else
      @products = p_summary[0]
      @product_count = p_summary[1]
    end
   
#    @q = products_pool.ransack(params[:q])
#    @q.sorts = 'name asc' if @q.sorts.empty?
#    @products = @q.result.paginate(page: params[:page], per_page: 100)
  end

  def show
    respond_with(@product)
  end
  
  def search  
    index
    render :index
  end

  def new
    @product = Product.new
    respond_with(@product)
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.save
    respond_with(@product)
  end

  def update
    @product.update(product_params)
    respond_with(@product)
  end

  def destroy
    @product.destroy
    respond_with(@product)
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params[:product]
    end
    
    def set_registries
      if user_signed_in? 
        registries = Registry.includes(:user_registries).where(:user_registries => { :user_id => @current_user.id, :association_type => ['owner', 'administrator'] } )
        if registries.empty?
          @registries = nil
        else
          @registries = registries.map { |r| [r.name, r.id] }
        end
      else
        @registries = nil
      end
    end
end
