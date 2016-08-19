class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, :only => [:show, :edit]

  def index
    @products = Product.order_by_id.paginate(:page => params[:page])
  end

  def edit
  end

  def search
    @products = Product.search(params[:q])
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

  def update
    @product = Product.find params[:id]
    if @product.update product_params
      flash[:danger] = false
      flash[:success] = "Product edited"
    end
    render 'new'
  end

  def autocomplete
    @products = Product.search(params[:q], {
      fields: ["name", "description"],
      limit: 6,
      load: false,
      misspellings: {edit_distance: 5},
      minimum_should_match: 1
    })
    render json: @products.map {|row| row.slice(:_id, :name)}
  end

  def result
    @products = Product.search(params[:q], {
      fields: ["name", "description"],
      limit: 9,
      load: false,
      misspellings: {edit_distance: 5},
      minimum_should_match: 1
    })
    flash[:query] = params[:q]
    if @products.size == 0
      flash[:danger] = "Nothing found"
    end
    @products.each { |row| logger.debug row}
    @products = @products.map {|row| row.slice(:_id, :name, :photo,
      :description, :price, :quantity)}
    render 'result'
  end

  def get_data
    @products = Product.search(params[:q], {
      fields: ["name", "description"],
      limit: 9,
      offset: params[:offset] || 0,
      load: false,
      misspellings: {edit_distance: 5},
      minimum_should_match: 1
    })
    flash[:query] = params[:q]
    if @products.size == 0
      flash[:danger] = "Nothing found"
      render html: "".html_safe and return
    end
    @products = @products.map {|row| row.slice(:_id, :name, :photo,
      :description, :price, :quantity)}
    render :partial => '/products/display2.html.erb', collection: @products, as: :product, 
      :formats => [:html]
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product)
            .permit(:name, :description, :photo, :price, :quantity)
    end
end
