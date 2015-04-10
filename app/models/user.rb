class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:user, :admin, :superadmin]
  after_initialize :set_default_role, :if => :new_record?

  validates :first_name, :last_name, presence: true

  def set_default_role
    self.role ||= :user
  end
end
