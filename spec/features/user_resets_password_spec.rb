require 'spec_helper'

feature 'user_resets_password' do
  background do
    clear_emails
    Fabricate(:user, email: 'joe@example.com', password: 'old_password')
    visit root_path
    click_link('Sign In')
    click_link('Forgot Password')
    fill_in('password_request_email', with: 'joe@example.com')
    click_button('Send Email')
    open_email('joe@example.com')
  end

  after { clear_email }

  scenario 'checking for content' do
    expect(current_email).to have_content "Hi #{User.first.full_name}"
  end

  scenario 'following a link' do
    current_email.click_link 'click here to reset'
    expect(page).to have_content('Reset Your Password')
  end

  scenario 'changing the password' do
    current_email.click_link 'click here to reset'
    fill_in('password', with: 'new_password')
    click_button('Reset Password')
    expect(page).to have_content('Your password has been changed')
  end

  scenario 'signing in with changed password' do
    current_email.click_link 'click here to reset'
    fill_in('password', with: 'new_password')
    click_button('Reset Password')
    fill_in('email', with: 'joe@example.com')
    fill_in('password', with: 'new_password')
    click_button('Sign in')
    expect(page).to have_content("Welcome, #{User.first.full_name}")
  end
end