class MessagesController < ApplicationController

  def index
    redirect_to inbox_messages_path
  end

  def inbox
    if current_user.role == "user"
      @messages = Message.where.not(sender_id: current_user).joins(:scenario_session).where(:scenario_sessions => { student_id: current_user } ).all
    else
      @messages = Message.where.not(sender_id: current_user).joins(:scenario_session).where(:scenario_sessions => { teacher_id: current_user } ).all
    end
  end

  def outbox
    @messages = Message.where(sender_id: current_user)
  end

  def new
    @message = Message.new
    # @scenario_session_options = ScenarioSession.where(teacher_id: current_user).map{|s| [s.id]}
    # abort(@scenario_session_options.inspect)
    # scenario_session has to be set automatically
  end

  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.send_at = Time.now.to_datetime
    @message.scenario_session_id = 1

    if @message.save
      redirect_to @message
    end

  end

  private
    def message_params
      params.require(:message).permit(:content, :role, :scenario_session_id)
    end

end
