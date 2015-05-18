class ScenarioSession < ActiveRecord::Base

  belongs_to :scenario
  belongs_to :teacher, :class_name => 'User'
  belongs_to :student, :class_name => 'User'
  has_many :messages

end
