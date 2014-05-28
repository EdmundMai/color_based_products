class Admin::ProductsController < Admin::BaseController
  
  def index
    @products = Product.all
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to edit_admin_product_path(@product), notice: "Your product was successfully updated."
    else
      render 'edit'
    end
  end
  
  def new
    @product = Product.new
    @product.variants.build
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to edit_admin_product_path(@product), notice: "Your product was successfully created."
    else
      render 'new'
    end
  end
  
  def generate_variants
    price = params[:price] || 0
    sizes_and_measurements = params[:sizes_and_measurements]
    colors_and_genders = params[:colors_and_genders]
    @products_colors = []
    colors_and_genders.each do |color_id, gender|
      product_color = ProductsColor.new(color_id: color_id,
                                        mens: gender.include?("men"),
                                        womens: gender.include?("women")
                                        )
      sizes_and_measurements.each do |size_id, measurements|
        product_color.variants << Variant.new(size_id: size_id,
                                          measurements: measurements,
                                          price: price)
      end
      @products_colors << product_color
    end

    respond_to do |format|
      format.js
    end
  end
  
  def add_size
    respond_to do |format|
      format.js
    end
  end
  
  def add_color
    respond_to do |format|
      format.js
    end
  end
  
  # def add_image
  #   respond_to do |format|
  #     format.js
  #   end
  # end
  
  def add_variant
    @product = Product.find(params[:product_id])
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def product_params
      params.require(:product).permit(:name, 
                                      :short_description, 
                                      :long_description, 
                                      :active, 
                                      :meta_description, 
                                      :page_title, 
                                      :vendor_id, 
                                      :material_id, 
                                      :shape_id, 
                                      :products_colors_attributes => [:id, 
                                        :mens, 
                                        :womens,
                                        :color_id,
                                        :_destroy, 
                                        :product_images_attributes => [:color_id, :image => []],
                                        :variants_attributes => (Variant.column_names.clone << :price << :_destroy)]
                                      )
    end
    
    def variant_params
      params.require(:variants).permit!
    end
    
    def product_image_params
      params.require(:product_images).permit!
    end
  
end