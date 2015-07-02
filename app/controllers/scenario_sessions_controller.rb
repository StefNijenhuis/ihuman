class ScenarioSessionsController < ApplicationController

  def new
    @scenarios_options = Scenario.all.map{|s| [s.title, s.id]}
    @teachers_options = User.where(role: [1,2]).map{|to| [to.fullname, to.id]}
    @students_options = User.where(role: 0).map{|so| [so.fullname, so.id]}

    @scenario_session = ScenarioSession.new
  end

  def show
    @scenario_session = ScenarioSession.where(id: params[:id]).last
  end

  def create
    @scenario_session = ScenarioSession.new(scenario_session_params)
    @scenario_session.teacher = current_user
    if @scenario_session.save
      send_briefing(@scenario_session)
      receiver_name = User.where(id: @scenario_session.student_id).first.fullname
      flash[:notice] = "De briefing is verstuurd naar #{receiver_name}"
      redirect_to admin_scenarios_path
    end
  end

  def send_briefing(scenario_session)
    @briefing = Message.new
    scenario = Scenario.where(id: scenario_session.scenario_id).first
    obj = JSON.parse scenario.content
    @briefing.content = obj["scenario"]['briefing']['content']
    @briefing.sender_id = scenario_session.teacher_id
    @briefing.scenario_session_id = scenario_session.id
    @briefing.role = "Opdracht gever"
    @briefing.send_at = Time.now.to_datetime
    @briefing.save
    update_progress
  end

  def update_progress
    # TODO: Figure out what the current id is
    #       Set the progress to the id of the next element in the scenario
    scenario = Scenario.where(id: @scenario_session.scenario_id).first
    obj = JSON.parse scenario.content

    if @scenario_session.progress == 0
      @scenario_session.progress = 1
    else

    end


    # @scenario_session.progress = obj["scenario"]['']
    if @scenario_session.save
      send_situation(@scenario_session)
      receiver_name = User.where(id: @scenario_session.student_id).first.fullname
      flash[:notice] = "De nieuwe situatie is verstuurd naar #{receiver_name}"
      redirect_to inbox_messages_path
    end

  end

  def send_situation(scenario_session)
    # TODO: Figure out which situation has te be send

    @situation = Message.new
    scenario = Scenario.where(id: scenario_session.scenario_id).first
    obj = JSON.parse scenario.content
    # @situation.content = obj["scenario"]['']
    @situation.sender_id = scenario_session.teacher_id
    @situation.scenario_session_id = scenario_session.id
    @situation.role = ""
    @situation.send_at = Time.now.to_datetime
    @situation.save
  end

  private
    def scenario_session_params
      params.require(:scenario_session).permit(:scenario_id, :student_id, :teacher_id, :start_date)
    end

end
