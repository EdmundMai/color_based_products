require 'spec_helper'

describe User do
  its(:attributes) { should include("email") }
  its(:attributes) { should include("encrypted_password") }
end
