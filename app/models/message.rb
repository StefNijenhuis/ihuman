class Message < ActiveRecord::Base

  belongs_to :sender, :class_name => 'User', :foreign_key => 'id'
  has_one :scenario_session

  validates :content, presence: true

end
