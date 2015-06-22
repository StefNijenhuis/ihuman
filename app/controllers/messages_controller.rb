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

  def show
    @message = Message.where(id: params[:id]).last
    @role = @message.role
  end

  def reply_new
    @message = Message.where(id: params[:id]).last
    @reply = Message.new
    $session_id = @message.scenario_session_id
  end

  def reply_create
    @reply = Message.new(message_params)
    @reply.scenario_session_id = $session_id
    @reply.role = @role
    @reply.send_at = Time.now.to_datetime
    @reply.sender = current_user

    @reply.save

    flash[:notice] = "Het bericht is verstuurd"
    redirect_to inbox_messages_path
  end

  def new
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
      params.require(:message).permit(:content)
    end
end
