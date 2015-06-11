class Admin::ScenariosController < ApplicationController
  before_action :authenticate_user_role

  def index
    @scenarios = Scenario.all
  end

  def new
    @scenario = Scenario.new
  end

  # def create
  #   @scenario = Scenario.new(scenario_params)
  #   if @scenario.save
  #     redirect_to @scenario
  #   end
  # end

  def ajax_save
    json = request.POST['data']
    obj = JSON.parse json
    title = obj["title"]
    # obj["scenario"]['briefing']['content']
    @scenario = Scenario.new
    @scenario.title = title
    @scenario.content = json
    if @scenario.save
      render :json => {status: "success"}
    else
      render :json => {status: "fail"}
    end

    render :json => {success:"Joy"}
  end

  def ajax_load
    abort("wow")
  end

end
