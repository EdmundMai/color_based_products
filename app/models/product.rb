class Product < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :shape
  belongs_to :material
  
  has_many :products_colors
  has_many :variants, through: :products_colors, dependent: :destroy
  has_many :product_images, through: :products_colors, dependent: :destroy
  
  accepts_nested_attributes_for :products_colors, :reject_if => :incomplete_products_color, :allow_destroy => true
  
  def products_colors_attributes=(attrs)
    if self.new_record?
      super(attrs)
    else
      attrs.each do |_, attributes|
        products_color = ProductsColor.where(color_id: attributes[:color_id], product_id: self.id).first_or_initialize
        products_color.update_attributes(attributes)
      end
    end
  end
  
  # has_many :variants, -> { order(size: :desc) }, after_remove: :reset_featured_colors!
  # has_many :product_images, -> { order(sort_order: :asc) }

  
  # validates_associated :variants
  # validate :variants_have_different_sizes_and_colors
  
  
  # def featurable_mens_colors
  #   self.mens_variants.where(active: true).map(&:color).compact.uniq
  # end
  # 
  # def featurable_womens_colors
  #   self.womens_variants.where(active: true).map(&:color).compact.uniq
  # end
  # 
  # def mens_variants
  #   self.variants.where(men: true)
  # end
  # 
  # def womens_variants
  #   self.variants.where(women: true)
  # end
  # 
  # def reset_featured_colors!(variant)
  #   return if variant.new_record?
  #   color = variant.color
  #   # if self.variants.where(color_id: color.id).empty?
  #   #   if self.featured_mens_color == color
  #   #     self.featured_mens_color = self.variants.first.color
  #   #     self.save
  #   #   end
  #   #   if self.featured_womens_color == color
  #   #     self.featured_womens_color = self.variants.first.color
  #   #     self.save
  #   #   end
  #   # end
  # end
  # 
  # def variants_have_different_sizes_and_colors
  #   existing_combinations = []
  #   self.variants.each do |variant|
  #     size_and_color_combination = [variant.size, variant.color]
  #     if !existing_combinations.include?(size_and_color_combination)
  #       existing_combinations << size_and_color_combination
  #     else
  #       self.errors.add(:base, "Variants can't have identical size and color")
  #     end
  #   end
  # end
  
  private
  
    def incomplete_products_color(attributed)
      attributed.keys == ["_destroy", "variants_attributes"] || attributed.keys == ["_destroy"]
    end
  
end
