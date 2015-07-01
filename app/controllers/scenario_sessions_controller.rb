class ScenarioSessionsController < ApplicationController

  def new
    @scenarios_options = Scenario.all.map{|s| [s.title, s.id]}
    @teachers_options = User.where(role: [1,2]).map{|to| [to.fullname, to.id]}
    @students_options = User.where(role: 0).map{|so| [so.fullname, so.id]}

    @scenario_session = ScenarioSession.new
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
  end

  private
    def scenario_session_params
      params.require(:scenario_session).permit(:scenario_id, :student_id, :teacher_id, :start_date)
    end

end
