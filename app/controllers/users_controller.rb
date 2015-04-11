class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, :only => :index
  skip_before_filter :verify_authenticity_token, :only => :invite_send

  def index
    @users = User.all
    authorize @users
  end

  def new
    @user = User.new()
  end

  def create
    @user = User.new()
    @user.email = email
    # randomPassword = (0...8).map { (65 + rand(26)).chr }.join

    if @user.save

    end
  end

  def invite

  end

  def invite_send
    user_array = params[:emails].split("\r\n")
    user_hash = Hash.new

    user_array.each do |email|



    end
  end


      # userCreateMailer.welcome_email(@user).deliver_late
  private
    def list_user_params
      params.require(:users).permit(:emails)
    end

end
