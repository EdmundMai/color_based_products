# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :products_color do
    color_id 1
    product_id 1
    mens false
    womens false
  end
end
