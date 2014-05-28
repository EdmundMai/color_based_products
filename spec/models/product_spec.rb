require 'spec_helper'

describe Product do
  its(:attributes) { should include("name") }
  its(:attributes) { should include("short_description") }
  its(:attributes) { should include("long_description") }
  its(:attributes) { should include("active") }
  its(:attributes) { should include("page_title") }
  its(:attributes) { should include("meta_description") }
  its(:attributes) { should include("vendor_id") }
  its(:attributes) { should include("shape_id") }
  its(:attributes) { should include("material_id") }
  
  it { should belong_to(:vendor) }
  it { should belong_to(:shape) }
  it { should belong_to(:material) }
  
  it { should have_many(:products_colors) }
  it { should have_many(:variants).through(:products_colors) }
  it { should have_many(:product_images).through(:products_colors) }
  
  it { should accept_nested_attributes_for(:products_colors) }
  
  # it { should have_many(:variants) }
  # it { should accept_nested_attributes_for(:variants) }
  # 
  # it { should have_many(:product_images) }
  # it { should accept_nested_attributes_for(:product_images) }
  
  # it { should have_many(:mens_colors) }
  
  
  # describe "callbacks" do
  #   context "when a variant has been destroyed" do
  #     context "that variant is the last of a particular color" do
  #       context "that variant's color is the featured womens color" do
  #         it "resets the featured mens color to another variant's color" do
  #           product = FactoryGirl.create(:product)
  #           variant1 = FactoryGirl.create(:variant, men: true)
  #           variant2 = FactoryGirl.create(:variant, men: true)
  #           product.variants << variant1
  #           product.variants << variant2
  #           product.featured_womens_color = variant1.color
  #           product.save
  #           product.variants.delete(variant1)
  #           expect(product.featured_womens_color).to eq variant2.color
  #         end
  #       end
  #       
  #       context "that variant's color is the featured mens color" do
  #         it "resets the featured mens color to another variant's color" do
  #           product = FactoryGirl.create(:product)
  #           variant1 = FactoryGirl.create(:variant, men: true)
  #           variant2 = FactoryGirl.create(:variant, men: true)
  #           product.variants << variant1
  #           product.variants << variant2
  #           product.featured_mens_color = variant1.color
  #           product.save
  #           product.variants.delete(variant1)
  #           expect(product.featured_mens_color).to eq variant2.color
  #         end
  #       end
  #     end
  #   end
  # end
  # 
  # describe "validations" do
  #   context "when the color and size of a variant are the same as another variant's" do
  #     it "should not save" do
  #       product = Product.new
  #       product.variants << Variant.new(size: "S", color_id: 1)
  #       product.variants << Variant.new(size: "S", color_id: 1)
  #       expect(product.save).to be_false
  #     end
  #   end
  # end
  # 
  # 
  # 
  # describe "#womens_variants" do
  #   it "returns an array variants that have women set to true" do
  #     product = FactoryGirl.create(:product)
  #     womens_variant = FactoryGirl.create(:variant, women: true)
  #     unwanted_variant = FactoryGirl.create(:variant, women: false)
  #     product.variants << womens_variant
  #     product.variants << unwanted_variant
  #     expect(product.womens_variants).to match_array [womens_variant]
  #   end
  # end
  # 
  # describe "#featurable_womens_colors" do
  #   context "there are no variants" do
  #     it "returns an empty array" do
  #       product = Product.new
  #       expect(product.featurable_womens_colors).to match_array []
  #     end
  #   end
  #   
  #   context "there are only inactive variants available for women" do
  #     it "returns an empty array" do
  #       product = FactoryGirl.create(:product)
  #       color1 = FactoryGirl.create(:color, name: "Red")
  #       product.variants << FactoryGirl.create(:variant, size: "S", color_id: color1.id, women: true, active: false)
  #       expect(product.featurable_womens_colors).to match_array []
  #     end
  #   end
  #   
  #   context "there are active variants" do
  #     it "returns an array of unique active variant colors available for women" do
  #       product = FactoryGirl.create(:product)
  #       color1 = FactoryGirl.create(:color, name: "Red")
  #       color2 = FactoryGirl.create(:color, name: "Blue")
  #       color3 = FactoryGirl.create(:color, name: "Green")
  #       product.variants << FactoryGirl.create(:variant, size: "S", color_id: color1.id, women: true, active: true)
  #       product.variants << FactoryGirl.create(:variant, size: "M", color_id: color1.id, women: true, active: true)
  #       product.variants << FactoryGirl.create(:variant, size: "S", color_id: color2.id, women: true, active: true)
  #       product.variants << FactoryGirl.create(:variant, size: "M", color_id: color3.id, women: false, active: true)
  #       expect(product.featurable_womens_colors).to match_array [color1, color2]
  #     end
  #   end
  # end
  # 
  # describe "#mens_variants" do
  #   it "returns an array variants that have men set to true" do
  #     product = FactoryGirl.create(:product)
  #     mens_variant = FactoryGirl.create(:variant, men: true)
  #     unwanted_variant = FactoryGirl.create(:variant, men: false)
  #     product.variants << mens_variant
  #     product.variants << unwanted_variant
  #     expect(product.mens_variants).to match_array [mens_variant]
  #   end
  # end
  # 
  # describe "#featurable_mens_colors" do
  #   context "there are no variants" do
  #     it "returns an empty array" do
  #       product = Product.new
  #       expect(product.featurable_mens_colors).to match_array []
  #     end
  #   end
  #   
  #   context "there are only inactive variants available for men" do
  #     it "returns an empty array" do
  #       product = FactoryGirl.create(:product)
  #       color1 = FactoryGirl.create(:color, name: "Red")
  #       product.variants << FactoryGirl.create(:variant, size: "S", color_id: color1.id, men: true, active: false)
  #       expect(product.featurable_mens_colors).to match_array []
  #     end
  #   end
  #   
  #   context "there are active variants" do
  #     it "returns an array of unique active variant colors available for men" do
  #       product = FactoryGirl.create(:product)
  #       color1 = FactoryGirl.create(:color, name: "Red")
  #       color2 = FactoryGirl.create(:color, name: "Blue")
  #       color3 = FactoryGirl.create(:color, name: "Green")
  #       product.variants << FactoryGirl.create(:variant, size: "S", color_id: color1.id, men: true, active: true)
  #       product.variants << FactoryGirl.create(:variant, size: "M", color_id: color1.id, men: true, active: true)
  #       product.variants << FactoryGirl.create(:variant, size: "S", color_id: color2.id, men: true, active: true)
  #       product.variants << FactoryGirl.create(:variant, size: "M", color_id: color3.id, men: false, active: true)
  #       expect(product.featurable_mens_colors).to match_array [color1, color2]
  #     end
  #   end
  # end
  
end
