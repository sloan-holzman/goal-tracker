class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :requests, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :competitions, dependent: :destroy
  validates :name, presence: true


  before_save do |group|
    group.name = group.name.downcase.titleize
  end

  def admin_reassign
    if self.users.length == 1 || self.memberships.where(admin: true).count == 0
      admin = self.users.first
      membership = Membership.where(group: self, user: admin)
      membership.update(admin: true)
    else self.users.length == 0
      self.destroy
    end
  end




end
