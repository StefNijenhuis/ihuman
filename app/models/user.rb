class User < ActiveRecord::Base

  has_many :messages
  has_many :scenario_sessions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:user, :admin, :superadmin]
  after_initialize :set_default_role, :if => :new_record?

  validates :first_name, :surname, presence: true

  def set_default_role
    self.role ||= :user
  end

  def fullname
    self.suffix.present? ? ("#{first_name} #{suffix} #{surname}") : ("#{first_name} #{surname}")
  end
end
