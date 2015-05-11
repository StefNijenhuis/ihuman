class Admin::UsersController < ApplicationController
  after_action :verify_authorized, :only => :index
  skip_before_filter :verify_authenticity_token, :only => :send_invites

  def index
    @users = User.all
    authorize @users
  end

  def invite
  end

  def send_invites
    emails = params[:emails].split("\r\n")
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