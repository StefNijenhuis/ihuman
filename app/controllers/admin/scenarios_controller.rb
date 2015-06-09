class Admin::ScenariosController < ApplicationController
  before_action :authenticate_user_role

  def index
    @scenarios = Scenario.all
  end

  def new
    @scenario = Scenario.new
  end

  def create
    @scenario = Scenario.new(scenario_params)
    if @scenario.save
      redirect_to @scenario
    end
  end

end
