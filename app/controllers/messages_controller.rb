class MessagesController < ApplicationController

  def create
    @message = Message.new
    if @message.save
    end

  end

end
