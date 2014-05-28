require 'spec_helper'

describe Variant do
  include MoneyRails::TestHelpers
  
  # its(:attributes) { should include("product_id") }
  its(:attributes) { should include("measurements") }
  its(:attributes) { should include("weight") }
  its(:attributes) { should include("size_id") }
  its(:attributes) { should include("price_cents") }
  its(:attributes) { should include("price_currency") }
  its(:attributes) { should include("sku") }
  its(:attributes) { should include("men") }
  its(:attributes) { should include("women") }
  its(:attributes) { should include("active") }
  
  # it { should belong_to(:product) }
  # it { should belong_to(:color) }
  
  it { should belong_to(:products_color) }
  it { should belong_to(:size) }
  
  it { should monetize(:price_cents).with_currency(:usd) }
  
  # context "on update" do
  #   subject { FactoryGirl.create(:variant) }
  #   it { should validate_presence_of(:color) }
  # end

  
end
