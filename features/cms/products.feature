Feature: Products
	
	Background:
		Given I am an authenticated admin user

	Scenario: Products index
		Given existing products
		When I visit the admin products index page
		Then I should see a list of products information
		
	@javascript
	Scenario: Creating a new product
		Given existing colors
		And existing vendors
		When I visit the admin products new page
		And I fill in the form to create a new product
		And I create multiple variants
		And I submit the product form
		Then my product should be saved
		And I should be on the edit product page
	
	@javascript
	Scenario: Adding colors to the products form
		When I visit the admin products new page
		And I add a color
		Then that color should be available in the variant generator color form
		
	Scenario: Editing a product
		Given existing products
		When I visit the admin products edit page
		And I add an image for default men's
		And I add an image for default women's
	
	@javascript
	Scenario: Adding vendors on the new product page
		When I visit the admin products new page
		And I create a new vendor named "Gucci"
		Then "Gucci" should be on the vendor list
		When I create a new vendor named "Armani"
		Then "Armani" should be on the vendor list
	
	@javascript
	Scenario: Adding colors on the new product page
		When I visit the admin products new page
		And I create a new color named "Blue"
		Then "Blue" should be on the color list