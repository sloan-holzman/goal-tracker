class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :metrics, dependent: :destroy
  has_many :performances, through: :metrics
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :requests, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  before_save do |user|
    user.last_name = user.last_name.downcase.titleize
    user.first_name = user.first_name.downcase.titleize
  end


  def find_approval_requests
    admin_memberships = self.memberships.where(admin: true)
    groups = []
    for membership in admin_memberships
      groups.push(membership.group)
    end
    approval_requests = []
    for group in groups
      for request in group.requests
        approval_requests.push(request)
      end
    end
    return approval_requests
  end


  def find_reminder_frequency
    if !self.reminder
      reminder_frequency_message = "Off"
    elsif self.reminder_frequency == "Weekly"
      reminder_frequency_message = "Every #{self.reminder_day}"
    else self.reminder
      reminder_frequency_message = "Daily"
    end
    return reminder_frequency_message
  end

end
