class MessagesController < ApplicationController

  def new
    @message = Message.new
    @scenario_session_options = ScenarioSession.where(teacher_id: current_user.id).map{|s| [s.id]}

  end

  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.send_at = DateTime
    if @message.save
      redirect_to @message
    end

  end

  private
    def message_params
      params.require(:message).permit(:content, :role, :scenario_session_id)
    end

end
