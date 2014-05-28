require 'spec_helper'

describe Material do
  its(:attributes) { should include "name" }
  
  it { should have_many(:products) }
end
