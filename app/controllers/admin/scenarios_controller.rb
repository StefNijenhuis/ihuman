class Admin::ScenariosController < ApplicationController
  #after_action :verify_authorized

    def index
    @scenarios = Scenario.all
  end

  def new
  end

end
