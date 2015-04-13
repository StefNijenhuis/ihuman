class InviteMailer < ApplicationMailer
  def invite_email(email, password)
    @password = password
    @email = email
    mail(to: email, subject: 'Account voor iHuman')
  end
end
