class ScenariosController < ApplicationController

  # roles still have to figerd out

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
      params.require(:scenario).permit(:roles)
    end

end
