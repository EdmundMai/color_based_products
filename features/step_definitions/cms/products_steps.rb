Given(/^existing products$/) do
  FactoryGirl.create_list(:product, 2)
end

Given(/^existing colors$/) do
  FactoryGirl.create_list(:color, 2)
end

Given(/^existing vendors$/) do
  FactoryGirl.create_list(:vendor, 2)
end



When(/^I visit the admin products index page$/) do
  visit admin_products_path
end

Then(/^I should see a list of products information$/) do
  expect(Product.count).to be > 0
  Product.all.each do |product|
    expect(page).to have_content(product.name)
  end
end

When(/^I visit the admin products new page$/) do
  visit new_admin_product_path
end

When(/^I fill in the form to create a new product$/) do
  fill_in("product[name]", with: "Lorem")
  fill_in("product[short_description]", with: "Ipsum")
  fill_in("product[long_description]", with: "Something")
  fill_in("product[page_title]", with: "My Page Title")
  fill_in("product[meta_description]", with: "My Meta Description")
  select(Vendor.first.name, from: "product[vendor_id]")
end

When(/^I create multiple variants$/) do
  fill_in("price", with: "11.11")
  
  first_size_inputs = first(".size_inputs")
  within(first_size_inputs) do
    select("S", from: "size")
    fill_in("measurements", with: "12-12-12")
  end

  click_link("Add Size")
  
  last_size_inputs = page.all(".size_inputs")[1]
  within(last_size_inputs) do
    select("M", from: "size")
    fill_in("measurements", with: "24-24-24")
  end
  
  select(Color.first.name, from: "color")
  first_mens_checkbox = page.all(".genders")[0]
  first_womens_checkbox = page.all(".genders")[1]
  expect(first_mens_checkbox).to be_checked
  expect(first_womens_checkbox).to be_checked
  
  click_link("Add Color")
  sleep 2
  
  second_mens_checkbox = page.all(".genders")[2]
  second_womens_checkbox = page.all(".genders")[3]
  expect(second_mens_checkbox).to be_checked
  expect(second_womens_checkbox).to be_checked
  
  last_color_inputs = page.all(".color_inputs")[1]
  within(last_color_inputs) do
    select(Color.last.name, from: "color")
    find(:css, ".genders:last-of-type").set(false)
  end
  
  click_link("Generate")
  sleep 2
  
  within(".variant_container") do
    expect(page).to have_css("table.variants_table tr", count: 5)
    expect(page).to have_field("product[variants_attributes][0][size]", with: "S")
    expect(page).to have_field("product[variants_attributes][1][size]", with: "S")
    expect(page).to have_field("product[variants_attributes][2][size]", with: "M")
    expect(page).to have_field("product[variants_attributes][3][size]", with: "M")
    expect(page).to have_field("product[variants_attributes][0][color_id]", with: Color.first.id)
    expect(page).to have_field("product[variants_attributes][1][color_id]", with: Color.last.id)
    expect(page).to have_field("product[variants_attributes][2][color_id]", with: Color.first.id)
    expect(page).to have_field("product[variants_attributes][3][color_id]", with: Color.last.id)
  end
  
  (0..3).each do |variant_index|
    fill_in("product[variants_attributes][#{variant_index}][price]", with: "11.22")
    fill_in("product[variants_attributes][#{variant_index}][sku]", with: "ABC123")
  end
end

When(/^I submit the product form$/) do
  click_button("Create Product")
end


Then(/^my product should be saved$/) do
  expect(Product.count).to eq(1)
  product = Product.last
  expect(product.name).to eq("Lorem");
  expect(product.short_description).to eq("Ipsum")
  expect(product.long_description).to eq("Something")
  expect(product.page_title).to eq("My Page Title")
  expect(product.meta_description).to eq("My Meta Description")
  expect(product.active).to be_false
  
  expect(product.vendor).to eq Vendor.first
  
  expect(product.variants.count).to eq(4)
  expect(product.variants.where(size: "S", 
                         measurements: "12-12-12",
                         men: true,
                         women: true,
                         price: 11.22,
                         sku: "ABC123",
                         color_id: Color.first.id)).not_to be_nil
   expect(product.variants.where(size: "S", 
                          measurements: "12-12-12",
                          men: true,
                          women: false,
                          price: 11.22,
                          sku: "ABC123",
                          color_id: Color.last.id)).not_to be_nil
                          
  expect(product.variants.where(size: "M", 
                         measurements: "24-24-24",
                         men: true,
                         women: true,
                         price: 11.22,
                         sku: "ABC123",
                         color_id: Color.first.id)).not_to be_nil
   expect(product.variants.where(size: "S", 
                         measurements: "24-24-24",
                         men: true,
                         women: false,
                         price: 11.22,
                         sku: "ABC123",
                         color_id: Color.last.id)).not_to be_nil
end

When(/^I try to generate a variant combination without selecting a size$/) do
  select(Color.first.name, from: "variant[color][]")
  click_link("Generate")
end

Then(/^I should be prompted to select a size$/) do
  expect(page).to have_content("Please select a size.")
end

Then(/^I should be on the edit product page$/) do
  product = Product.last
  expect(current_path).to eq(edit_admin_product_path(product))
end

When(/^I create a new vendor named "(.*?)"$/) do |vendor_name|
  find("option[id='new_vendor_option']").click
  fill_in("vendor[name]", with: vendor_name)
  find(:id, 'new_vendor_text_field').native.send_keys(:enter)
end

Then(/^"(.*?)" should be on the vendor list$/) do |vendor_name|
  expect(page).to have_select("product[vendor_id]", with_options: [vendor_name])
end

When(/^I create a new color named "(.*?)"$/) do |color_name|
  find("option[id='new_color_option']").click
  fill_in("color[name]", with: color_name)
  find(:id, 'new_color_text_field').native.send_keys(:enter)
end

Then(/^"(.*?)" should be on the color list$/) do |color_name|
  expect(page).to have_select("color", options: [color_name, "Create a new color..."])
end