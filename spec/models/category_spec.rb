require 'spec_helper'

describe Category do
  its(:attributes) { should include("parent_id") }
  its(:attributes) { should include("name") }
  its(:attributes) { should include("description") }
  its(:attributes) { should include("level") }
  its(:attributes) { should include("sort_order") }
  
  it { should have_many(:subcategories) }
  it { should belong_to(:parent_category) }
  
  describe ".all_first_level_categories" do
    let(:category) { FactoryGirl.create(:first_level_category) }
    it "returns all the categories without parents" do
      expect(category.parent_id).to be_nil
      expect(Category.all_first_level_categories).to include(category)
    end

    it "does not return categories with parents" do
      subcategory = FactoryGirl.create(:second_level_category)
      expect(Category.all_first_level_categories).not_to include(subcategory)
    end
  end
  
  
  describe ".all_second_level_categories" do
    let(:category) { FactoryGirl.create(:category) }
    it "should return all second level categories" do
      child = category.subcategories.build(name: 'Child Category', description: 'Lorem Ipsum')
      child.save!
      expect(Category.all_second_level_categories).to match_array [child]
    end
  end
  
  describe ".all_third_level_categories" do
    let(:category) { FactoryGirl.create(:category) }
    it "should return all third level categories" do
      child = category.subcategories.build(name: 'Child Category', description: 'Lorem Ipsum')
      child.save!
      grandchild = child.subcategories.build(name: 'Grandkid Category', description: 'Lorem Ipsum')
      grandchild.save!
      Category.all_third_level_categories.should match_array [grandchild]
    end

    it "should not return first level categories" do
      Category.all_third_level_categories.should_not include(category)
    end

    it "should not return second level categories" do
      child = category.subcategories.build(name: 'Child Category', description: 'Lorem Ipsum')
      child.save!
      Category.all_third_level_categories.should_not include(child)
    end
  end
end
