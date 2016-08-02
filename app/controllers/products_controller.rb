class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit]

  def index
    @products = Product.paginate(:page => params[:page])
  end

  def show
  end

  def edit
  end

  def search
    @products = Product.search_by_key(params[:keyword]).paginate(:page => params[:page])
    render 'index'
  end

  def new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = "Product added"
      render 'new'
    else
      flash[:error] = "Something went wrong, try again"
      render 'new'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :photo, 
                                      :price, :quantity)
    end
end
