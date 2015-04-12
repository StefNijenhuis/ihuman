class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :first_login

  private

  def first_login
    if params[:controller] != 'registrations' &&
       params[:controller] != 'devise/sessions' &&
       user_signed_in? &&
       !current_user.activated

       alert = "hello"
      return redirect_to edit_user_registration_path
    end
  end

end
