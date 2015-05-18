class Message < ActiveRecord::Base

  belongs_to :sender, :class_name => 'User'
  belongs_to :scenario_session

  # validates :content, presence: true

end
