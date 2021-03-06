class Admin::ScenariosController < ApplicationController
  before_action :authorize_admin

  def index
    @scenarios = Scenario.all
    @scenario_sessions = ScenarioSession.all
  end

  def new
    @scenario = Scenario.new
  end

  def edit
    @scenario = params[:id]
  end

  # def create
  #   @scenario = Scenario.new(scenario_params)
  #   if @scenario.save
  #     redirect_to @scenario
  #   end
  # end

  def ajax_save
    id = request.POST['id']
    json = request.POST['data']
    obj = JSON.parse json
    title = obj["title"]
    # obj["scenario"]['briefing']['content']
    if id == "null"
      @scenario = Scenario.new
    else
      @scenario = Scenario.where(id:id).last
    end

    @scenario.title = title
    @scenario.content = json

    if @scenario.save
      render :json => {status: "success", id: @scenario.id}
      # TODO: Redirect to scenario index
      # flash[:notice] = "Scenario is opgeslagen"
      # redirect_to admin_scenarios_path
    else
      render :json => {status: "fail"}
    end
  end

  def ajax_load
    id = request.GET['id']
    if @scenario = Scenario.where(id:id).last
      render :json => {status: "success", id: @scenario.id, data: @scenario.content}
    else
      render :json => {status: "not found"}
    end

  end

end
