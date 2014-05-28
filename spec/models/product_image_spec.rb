require 'spec_helper'

describe ProductImage do
  its(:attributes) { should include("product_id") }
  its(:attributes) { should include("color_id") }
  its(:attributes) { should include("image") }
  its(:attributes) { should include("sort_order") }
  
  # it { should belong_to(:product) }
  # it { should belong_to(:color) }
  # 
  it { should belong_to(:products_color) }
  

end
