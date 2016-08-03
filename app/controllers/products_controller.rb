class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit]

  def index
    @products = Product.order_by_id.paginate(:page => params[:page])
  end

  def show
    #@product = Product.find_by :id => params[:id]
  end

  def edit
  end

  def search
    @products = Product.search_by_key(params[:q]).paginate(:page => params[:page])
    if @products.size == 0
      flash[:danger] = "Nothing found"
      @products = Product.order_by_id.paginate(:page => params[:page])
    end
    render 'index'
  end

  def new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:danger] = false
      flash[:success] = "Product added"
    end
    render 'new'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product)
            .permit(:name, :description, :photo, :price, :quantity)
    end
end
