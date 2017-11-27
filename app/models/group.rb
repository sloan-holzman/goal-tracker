class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :requests, dependent: :destroy
  has_many :invitations, dependent: :destroy
  validates :name, presence: true


  before_save do |group|
    group.name = group.name.downcase.titleize
  end

end
