# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_image do
    name "MyString"
    image { fixture_file_upload("#{Rails.root}/spec/support/sample_img.jpg", 'image/jpg') }
    product_id 1
  end
end
