class Metric < ApplicationRecord
  belongs_to :user
  has_many :performances, dependent: :destroy
  validates :name, :unit, :target, :duration, {presence: true}
end
