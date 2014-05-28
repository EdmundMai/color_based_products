# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "Lorem"
    description "Ipsum"
    active true
    page_title "My Title"
    meta_description "My Meta Description"
    
    factory :product_with_variants do
      after(:create) do |product, evaluator|
        product.variants << FactoryGirl.create(:variant, color: "Red", product_id: product.id)
        product.variants << FactoryGirl.create(:variant, color: "Blue", product_id: product.id)
      end
    end

  end
end
