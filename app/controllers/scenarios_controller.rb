class ScenariosController < ApplicationController

  def create
    @scenario = Scenario.new
    if @scenario.save
    end

  end

end
