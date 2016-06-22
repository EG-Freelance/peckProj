class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  respond_to :html
  
  def add_to_registry
  end

  def index
    products_pool = Product.all
    
    @q = products_pool.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @products = @q.result.paginate(page: params[:page], per_page: 24)
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
end
