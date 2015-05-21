class MessagesController < ApplicationController

  def index
      if current_user.role = 1
        @messages = Message.where.not(sender_id: current_user).joins(:scenario_session).where(:scenario_sessions => { student_id: current_user } ).all
      else
        @messages = Message.where.not(sender_id: current_user).joins(:scenario_session).where(:scenario_sessions => { teacher_id: current_user } ).all
      end
  end

  def new
    @message = Message.new
    @scenario_session_options = ScenarioSession.where(teacher_id: current_user.id).map{|s| [s.id]}
    # scenario_session has to be set automatically
  end

  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.send_at = Time.now.to_datetime

    if @message.save
      redirect_to @message
    end

  end

  private
    def message_params
      params.require(:message).permit(:content, :role, :scenario_session_id)
    end

end
