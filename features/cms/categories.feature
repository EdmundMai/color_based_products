Feature: Categories
	In order to create/edit/delete categories
	As an admin user
	I want to have an interface to do this

	Background:
		Given I am an authenticated admin user

	@javascript
	Scenario: Index page
		Given existing categories
		When I visit the categories index page
		Then I should only see a list of first level categories
		When I click on one of the first level categories
		Then its subcategories should show
		When I click on one of the second level categories
		Then the second level category's subcategories should show
		
	Scenario: Categories search
		Given existing categories
		When I visit the categories index page
		And I search a second level category
		Then it should show up under its parent category
		When I search a third level category
		Then it should show its ancestors

	@javascript
	Scenario: Create new category
		Given existing books
		And existing collections
		When I create a new category
		And add books to that category
		And add collections to that category
		Then I should see those books and collections in the category show page
	
	@javascript
	Scenario: Searching for books
		Given existing books
		And existing categories
		When I visit the add books page
		And I search the title, theme, guided reading, language, and lexile of a book
		Then I should see book results
		
	Scenario: Viewing categories
		Given existing categories
		When I view a category page
		Then I should see the the category's properties
	
	Scenario: Editing a category
		Given existing categories
		When I edit a category
		And I remove a book
		And I remove a collection
		Then the category should be updated with no books and no collections
		
	Scenario: Deleting a category
		Given existing categories
		When I delete a category page
		Then it shouldn't appear anymore
	
	@javascript
	Scenario: Setting the parent category
		Given an existing first level category
		When I create a child category
		Then my child category should be associated with the first level category
		
	@javascript
	Scenario: Removing existing books
		Given existing categories
		When I visit a category's manage books page
		And I uncheck a book result
		Then the category should not have the book anymore
		
	@javascript
	Scenario: Searching for an incorrect lexil
		Given existing categories
		When I visit a category's manage books page
		And I enter "123ABC" in the lexile search field
		Then I should be prompted to change my lexile search term
		
	Scenario: Creating subcategories of an existing category
		Given existing categories
		When I view a category page
		And I click on the "New subcategory" link
		Then I should be redirected to the new category page
		And the parent category should be selected
	
	@javascript
	Scenario: Adding and removing books in bulk
		Given an existing category with no books
		And existing books
		When I visit a category's manage books page
		And I click the select all books checkbox
		Then the category should have all the books on the page
		When I unclick the select all books checkbox
		Then the category should not have any of the books on the page