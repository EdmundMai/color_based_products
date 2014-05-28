require 'spec_helper'

describe Color do
  its(:attributes) { should include("name") }
  
  it { should have_many(:products_colors) }
  
  
end