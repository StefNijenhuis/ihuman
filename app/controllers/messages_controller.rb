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
    $role = @message.role
  end

  def reply_new
    @message = Message.where(id: params[:id]).last
    @reply = Message.new
    $session_id = @message.scenario_session_id
  end

  def reply_create
    @reply = Message.new(message_params)
    @reply.scenario_session_id = $session_id
    @reply.role = $role
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

  def update_progress
    # TODO: Figure out what the current id is
    #       Set the progress to the id of the next element in the scenario
    @scenario_session = ScenarioSession.where(id: message.scenario_session_id).first
    scenario = scenario = Scenario.where(id: scenario_session.scenario_id).first
    obj = JSON.parse scenario.content

    # @scenario_session.progress = obj["scenario"]['']
    if @scenario_session.save
      send_situation(@scenario_session)
      receiver_name = User.where(id: @scenario_session.student_id).first.fullname
      flash[:notice] = "De nieuwe situatie is verstuurd naar #{receiver_name}"
      redirect_to outbox_messages_path
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
    def message_params
      params.require(:message).permit(:content)
    end
end
