class WelcomeMailer < ApplicationMailer

  default from: 'app82050338@heroku.com'

  def welcome_send(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Blocipedia!")
  end

end
