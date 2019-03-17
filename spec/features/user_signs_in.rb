require 'spec_helper'

feature 'User signs in' do
  scenario 'with valid credendtials' do
    user_signs_in
    expect(page).to have_content "Welcome, #{bob.full_name}"
    expect(page).to have_content "You are logged in"
  end

  scenario 'when already signed in' do
    user_signs_in
    visit login_path
    expect(page).to have_content "Welcome, #{bob.full_name}"
  end

  scenario 'with invalid password' do
    bob = Fabricate(:user, password: "foo")
    user_signs_in(bob)
    expect(page).to have_content "There was a problem with your username or password"
  end
end