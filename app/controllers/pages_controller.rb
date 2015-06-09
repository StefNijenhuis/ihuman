class PagesController < ApplicationController

  def home
    if current_user.role == "superadmin" || current_user.role == "admin"
      render "pages/home_admin"
    else
      render "pages/home_student"
    end
  end

  def unauthorized

  end

end
