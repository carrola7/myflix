require 'spec_helper'

feature 'invitation' do
  background do
    clear_email
  end

  after { clear_email }

  scenario 'user sends out an invitation and has it fulfilled' do
    bob = Fabricate(:user, password: "password")
    user_signs_in(bob)
    invite_friend
    open_mail
    expect(current_email).to have_content "Hi Joe Bloggs"
    expect(page).to have_content('Your invitation has been sent')
    sign_out
    current_email.click_link('click here to join')
    visit invitation_path(Invitation.first)
    clear_email
    expect(find('#user_email').value).to eq('joe@example.com')
    fill_in_sign_up_form
    open_mail
    expect(current_email).to have_content "Hi Joe Bloggs"
    click_people
    expect(page).to have_content("#{bob.full_name}")
    sign_out
    user_signs_in(bob)
    click_people
    expect(page).to have_content("Joe Bloggs")
    clear_email
  end

  def invite_friend
    click_link 'People'
    click_link 'Invite a Friend'
    fill_in(:invitation_name, with: 'Joe Bloggs')
    fill_in(:invitation_email, with: 'joe@example.com')
    click_button('Send Invitation')
  end

  def sign_out
    click_link('Sign Out')
  end

  def open_mail
    open_email('joe@example.com')
  end

  def fill_in_sign_up_form
    fill_in(:user_password, with: 'password')
    fill_in(:user_full_name, with: 'Joe Bloggs')
    click_button('Sign Up')
  end

  def click_people
    click_link('People')    
  end
end