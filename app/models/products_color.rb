class ProductsColor < ActiveRecord::Base
  has_many :variants, dependent: :destroy
  has_many :product_images, -> { order("sort_order ASC") }, dependent: :destroy
  
  accepts_nested_attributes_for :variants, :reject_if => :incomplete_variant, :allow_destroy => true
  accepts_nested_attributes_for :product_images, :reject_if => proc { |attributes| attributes['image'].blank? }, :allow_destroy => true
  
  belongs_to :product
  belongs_to :color
  
  validates_presence_of :color
  
  
  private
  
    def incomplete_variant(attributed)
      attributed.keys == ["_destroy"]
    end
end
