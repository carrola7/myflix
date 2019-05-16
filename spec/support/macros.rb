def set_current_user(user = nil)
  alice = user ? user : Fabricate(:user)
  session[:user_id] = alice.id
end

def set_current_admin(user = nil)
  alice = user ? user : Fabricate(:admin)
  session[:user_id] = alice.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def user_signs_in(user = nil)
  user = user || Fabricate(:user, password: "password")
  visit login_path
  fill_in :email, with: user.email
  fill_in "Password", with: "password"
  click_button "Sign in"
end