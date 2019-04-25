class AppMailer < ActionMailer::Base
  def notify_on_signup(user)
    @user = user
    mail from: 'noreply@myflix-ac.com',
         to: user.email,
         subject: 'Welcome to MyFlix!'
  end
end