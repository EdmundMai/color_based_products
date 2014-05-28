# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variant do
    product_id 1
    weight "9.99"
    measurements "MyString"
    size "MyString"
    color
  end
end
