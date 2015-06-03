class Admin::ScenariosController < ApplicationController
  #after_action :verify_authorized

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
