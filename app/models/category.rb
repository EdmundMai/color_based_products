class Category < ActiveRecord::Base
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy, after_add: :set_level
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_id"
  
  scope :all_first_level_categories, -> { where("level = 1") }
  scope :all_second_level_categories, -> { where("level = 2") }
  scope :all_third_level_categories, -> { where("level = 3") }
  
  protected
  
    def set_level(subcategory)
      subcategory.level = self.level + 1
      subcategory.save
    end
end
