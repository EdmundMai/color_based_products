SAMPLE_IMAGE_PATH = "#{Rails.root}/spec/support/sample_img.jpg"

Given(/^existing categories$/) do
  FactoryGirl.create(:third_level_category)
end

When(/^I visit the categories index page$/) do
  visit admin_categories_path
  page.should have_selector("#q_title_cont")
end

Then(/^I should only see a list of first level categories$/) do
  category = Category.where('parent_id IS NULL').first
  page.should have_content(category.title)
  child_category = Category.where('parent_id IS NOT NULL').first
  page.should_not have_content(child_category.title)
end

When(/^I click on one of the first level categories$/) do
  parent_category = Category.all_first_level_categories.last
  within("#first_level_cat_links_#{parent_category.id}") do
    find(:css, '.first_level_cat_link').click
  end
  sleep 5
end

Then(/^its subcategories should show$/) do
  category = Category.all_first_level_categories.last.subcategories.last
  page.should have_content(category.title)
  page.should have_link('New subcategory')
end

When(/^I click on one of the second level categories$/) do
  parent_category = Category.all_first_level_categories.last
  within("#first_level_cat_links_#{parent_category.id}") do
    find(:css, ".second_level_cat_link").click
  end
  sleep 5
end

Then(/^the second level category's subcategories should show$/) do
  subcategory = Category.all_first_level_categories.last.subcategories.first
  grandchild = subcategory.subcategories.first
  page.should have_link(grandchild.title)
  page.should have_link('New subcategory')
end

When(/^I create a new category$/) do
  visit new_admin_category_path
  current_path.should == new_admin_category_path
  fill_in('category[title]', with: 'Test')
  fill_in('category[description]', with: 'Lorem')
  attach_file('category[image_attributes][file]', SAMPLE_IMAGE_PATH)
  click_button('Create Category')
end

Then(/^I should see it in the category index page$/) do
  current_path.should == admin_categories_path
  category = Category.last
  page.should have_content(category.title)
end

When(/^I view a category page$/) do
  Category.all.count.should_not eq(0)
  category = Category.all_first_level_categories.first
  visit admin_category_path(category)
end

Then(/^I should see the the category's properties$/) do
  page.should have_content('Description')
  page.should have_content('Image')
  page.should have_link('Edit')
  page.should have_link('Delete')
  page.should have_link('Manage books')
  page.should have_link('Manage collections')
end

When(/^I edit a category$/) do
  category = Category.last
  visit edit_admin_category_path(category)
  current_path.should == edit_admin_category_path(category)
  page.should_not have_link("Edit")
  page.should have_link("Manage books")
  page.should have_link("Manage collections")
  fill_in('category[title]', with: 'New title')
  fill_in('category[description]', with: 'New description')
  click_button('Update')
  

end

When(/^I remove a book$/) do
  category = Category.last
  category.books.count.should eq(1)
  visit add_books_admin_category_path(category)
  current_path.should == add_books_admin_category_path(category)
  first('.remove_book_from_cat_link').click
end

When(/^I remove a collection$/) do
  category = Category.last
  category.collections.count.should eq(1)
  visit add_collections_admin_category_path(category)
  current_path.should == add_collections_admin_category_path(category)
  first('.remove_collection_from_cat_link').click
end

Then(/^the category should be updated with no books and no collections$/) do
  category = Category.last
  category.books.should be_empty
  category.collections.should be_empty
  visit admin_category_path(category)
  current_path.should == admin_category_path(category)
  page.should have_content(category.title)
  page.should have_content(category.description)
end

Given(/^an existing first level category$/) do
  FactoryGirl.create(:first_level_category)
end

When(/^I create a child category$/) do
  parent_category = Category.all_first_level_categories.first
  parent_category.should_not be_nil
  
  visit new_admin_category_path
  sleep 20
  select(parent_category.title, from: "parent_id" )
  fill_in('category[title]', with: 'New title')
  fill_in('category[description]', with: 'New description')
  click_button('Create Category')
end

Then(/^my child category should be associated with the first level category$/) do
  parent_category = Category.all_first_level_categories.first
  child_category = parent_category.subcategories.first
  visit admin_category_path(child_category)
  page.should have_content(parent_category.title)
end

When(/^add books to that category$/) do
  category = Category.last
  current_path.should == add_books_admin_category_path(category)
  page.should have_link("Edit")
  page.should_not have_link("#{category.title}'s Books")
  find(:css, "input[value='#{Book.first.id.to_s}']").set(true)
  sleep 5
end

Then(/^I should see those books and collections in the category show page$/) do
  category = Category.last
  visit admin_category_path(category)
  page.should have_content(category.title)
  page.should have_content(category.description)
  page.should have_content(Book.first.title)
  page.should have_content(Collection.first.name)
end


When(/^I change the books of a category$/) do
  category = Category.first
  category.books << FactoryGirl.create(:book, title: 'existing book')
  @books = category.books
  visit add_books_admin_category_path(category)
  current_path.should == add_books_admin_category_path(category)
  
  page.should have_link("Edit")
  page.should_not have_link("#{category.title}'s Books")

  first(:css, "input[value='#{category.books.first.id}']").set(false)
  find(:css, "input[value='#{Book.last.id - 1}']").set(true)
end

When(/^I cancel my edits$/) do
  click_button("Revert Changes")
end

Then(/^my category should be left unchanged$/) do
  category = Category.first
  @books.should eq(category.books)
end

When(/^I delete a category page$/) do
  @category = Category.first
  visit admin_category_path(@category)
  click_link('Delete category')
end

Then(/^it shouldn't appear anymore$/) do
  Category.find_by_id(@category.id).should be_nil
end


When(/^I search a second level category$/) do
  child_category = Category.where('parent_id IS NOT NULL').first
  fill_in("q[title_cont]", with: child_category.title)
  click_button("Search")
end

Then(/^it should show up under its parent category$/) do
  child_category = Category.where('parent_id IS NOT NULL').first
  page.should have_content(child_category.title)
  page.should have_content(child_category.parent_category.title)
end

When(/^I search a third level category$/) do
  grandchild = Category.all_third_level_categories.first
  fill_in("q[title_cont]", with: grandchild.title)
  click_button("Search")
end

Then(/^it should show its ancestors$/) do
  grandchild = Category.all_third_level_categories.first
  page.should have_content(grandchild.title)
  page.should have_content(grandchild.parent_category.title)
  page.should have_content(grandchild.parent_category.parent_category.title)
end

When(/^I visit a category's manage books page$/) do
  category = Category.last
  visit add_books_admin_category_path(category)
end


When(/^I uncheck a book result$/) do
  category = Category.last
  category.books.should_not be_empty
  
  category.books.each do |book|
    find(:css, "#book_checkbox_#{book.id}").set(false)
  end
end

Then(/^the category should not have the book anymore$/) do
  sleep 5
  category = Category.last
  category.books.should be_empty
end

When(/^add collections to that category$/) do
  category = Category.last
  visit add_collections_admin_category_path(category)
  find(:css, "input[value='#{Collection.first.id}']").set(true)
  sleep 3
end

When(/^I visit the add books page$/) do
  category = Category.first
  visit add_books_admin_category_path(category)
  current_path.should == add_books_admin_category_path(category)
end

Then(/^I should see book results$/) do
  book = Book.first
  within('.book_results') do
    page.should have_content(book.title)
  end
end

When(/^I click on the "(.*?)" link$/) do |link_name|
  click_link(link_name)
end

Then(/^I should be redirected to the new category page$/) do
  current_path.should == new_admin_category_path
end

Then(/^the parent category should be selected$/) do
  find(:css, "#parent_id").value.should == Category.all_first_level_categories.first.id.to_s
end

Given(/^a (.*?) book$/) do |language|
  book = FactoryGirl.create(:book)
  book.languages << FactoryGirl.create(:language, name: language)
end

When(/^I search for (.*?) books$/) do |language|
  select(language, from: 'q[languages_id_in][]')
end

Given(/^an existing category with no books$/) do
  category = FactoryGirl.create(:category)
  category.books = []
  category.save!
  category.books.should be_empty
end

When(/^I click the select all books checkbox$/) do
  find(:css, "#select_all_books_checkbox").set(true)
  sleep 3
end

Then(/^the category should have all the books on the page$/) do
  category = Category.last
  category.books.should_not be_empty
  
  page.all(:css, ".book_checkboxes").each do |book_checkbox|
    book_checkbox.should be_checked
  end
end

When(/^I unclick the select all books checkbox$/) do
  find(:css, "#select_all_books_checkbox").set(false)
  sleep 3
end

Then(/^the category should not have any of the books on the page$/) do
  category = Category.last
  category.books.should be_empty
  page.all(:css, ".book_checkboxes").each do |book_checkbox|
    book_checkbox.should_not be_checked
  end
end
