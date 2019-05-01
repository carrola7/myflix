class AppMailer < ActionMailer::Base
  def notify_on_signup(user)
    @user = user
    mail from: 'noreply@myflix-ac.com',
         to: user.email,
         subject: 'Welcome to MyFlix!'
  end

  def send_password_request_link(password_request)
    @password_request = password_request
    mail from: 'noreply@myflix-ac.com',
         to: password_request.user.email,
         subject: 'Reset your password'
  end

  def send_invitation(invite)
    @invite = invite
    mail from: 'invitations@myflix-ac.com',
           to: invite.email,
           subject: "#{invite.sender.full_name} has invited you to Myflix"
  end
end