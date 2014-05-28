# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "Category Name"
    description "Lorem Ipsum"
    level 1
    # association :image, :factory => :category_image
    after(:create) do |category, evaluator|
      # category.books << FactoryGirl.create(:book)
      # category.collections << FactoryGirl.create(:collection)
    end
    
    factory :first_level_category do
      name "first level"
      parent_id nil
      level 1
    end
    
    factory :second_level_category do
      name "second level"
      level 2
      association :parent_category, factory: :category
    end
    
    factory :third_level_category do
      name "third level"
      level 3
      after(:create) do |category, evaluator|
        second_level = FactoryGirl.create(:second_level_category)
        second_level.subcategories << category
      end
    end
    
    factory :category_with_sort_order do
      sequence(:sort_order) {|n| n }
    end
  end
end
