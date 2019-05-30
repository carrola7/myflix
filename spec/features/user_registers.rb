require 'spec_helper'

feature 'user registers', js: true do
  background  do 
    clear_email
    visit register_path
  end 
  after { clear_email }

  scenario 'with valid credit card', :vcr do
    fill_in_form('4242424242424242')
    expect(page).to have_content("Welcome, Joe")
  end
  scenario 'with invalid credit card', :vcr do
    fill_in_form('4000000000000069')
    expect(page).to have_content("Your card has expired.")
  end
  scenario 'with declined credit card', :vcr do
    fill_in_form('4000000000000002')
    expect(page).to have_content("Your card was declined.")
  end
end

def fill_in_form(cc_number)
  fill_in(:user_email, with: 'joe@example.com')
  fill_in(:user_password, with: 'password')
  fill_in(:user_full_name, with: 'Joe Bloggs')
  within_frame(find('iframe')) do
    find('input[name="cardnumber"]').set(cc_number)
    find('input[name="exp-date"]').set('0122')
    find('input[name="cvc"]').set('123')
    find('input[name="postal"]').set('12345')
  end
  click_button('Sign Up')  
  sleep 2
end