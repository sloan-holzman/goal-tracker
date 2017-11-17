class Metric < ApplicationRecord
  belongs_to :user
  has_many :performances
  validates :name, :unit, :target, :duration, {presence: true}
end
