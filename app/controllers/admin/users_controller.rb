class Admin::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :send_invites
  before_action :authenticate_user_role

  def index
    @users = User.all
  end

  def invite
  end

  def send_invites

    emails = params[:emails].split(
    /\s*[,;]\s* # comma or semicolon, optionally surrounded by whitespace
    |           # or
    \s{1,}      # one or more whitespace characters
    |           # or
    [\r\n]+     # any number of newline characters
    /x)
    # Source: http://stackoverflow.com/questions/8961930/split-on-newlines-and-commas-and-semi-colons

    emails.each do |email|
      password = SecureRandom.hex(4)
      user = User.new({
        :email => email,
        :password => password,
        :password_confirmation => password
      })
      if user.save(:validate => false)
        InviteMailer.invite_email(email, password).deliver
      end
    end
  end

  private
    def list_user_params
      params.require(:users).permit(:emails)
    end

end
