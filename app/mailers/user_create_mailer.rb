class UserCreateMailer < ApplicationMailer

 def welcome_email(user)
    @randomPassword = @user.password
    mail(to: @user.email, subject: 'Account voor iHuman')
  end

end
