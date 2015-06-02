class ScenarioSessionsController < ApplicationController

  def new
    @scenarios_options = Scenario.all.map{|s| [s.id]}
    @teachers_options = User.where(role: [1,2]).map{|to| [to.first_name, to.id]}
    @students_options = User.where(role: 0).map{|so| [so.first_name, so.id]}

    @scenario_session = ScenarioSession.new
  end

  def create
    @scenario_session = ScenarioSession.new(scenario_session_params)
    @scenario_session.teacher_id = current_user
    if @scenario_session.save
      redirect_to @scenario_session
    end

  end

  private
    def scenario_session_params
      params.require(:scenario_session).permit(:scenario_id, :student_id, :teacher_id, :start_date)
    end

end
