class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_filter :remove_authentication_flash_message_if_root_url_requested
  before_action :first_login

  private

  # Redirect unactivated users to the edit account page
  def first_login
    if params[:controller] != 'registrations' &&
       params[:controller] != 'devise/sessions' &&
       user_signed_in? &&
       !current_user.activated

      return redirect_to edit_user_registration_path
    end
  end

  def authenticate_user_role
    if current_user.role == "user"
      redirect_to unauthorized_path
    end
  end

  def authorize_admin
    redirect_to unauthorized_path unless current_user.admin? || current_user.superadmin?
  end

  def remove_authentication_flash_message_if_root_url_requested
    if session[:user_return_to] == root_path and flash[:alert] == I18n.t('devise.failure.unauthenticated')
      flash[:alert] = nil
    end
  end

end
