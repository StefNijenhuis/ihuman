class ScenariosController < ApplicationController

  def new
    @scenario = Scenario.new
  end

  def create
    @scenario = Scenario.new(scenario_params)
    if @scenario.save
      redirect_to @scenario
    end

  end

  private
    def scenario_params
      params.require(:scenario).permit(:roles, :time_budget, :money_budget, :title, :description, :content)
    end

end
