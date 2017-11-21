class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships #This can be members also using `class_name`
end
