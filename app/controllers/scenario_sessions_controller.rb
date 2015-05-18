class ScenarioSessionsController < ApplicationController

  def create
    @scenario_session = Scenario_session.new
    if @scenario_session.save
    end

  end

end
