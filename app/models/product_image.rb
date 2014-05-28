class ProductImage < ActiveRecord::Base
  mount_uploader :image, ProductImageUploader
  belongs_to :product
  belongs_to :color
end
