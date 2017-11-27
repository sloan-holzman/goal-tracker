class Metric < ApplicationRecord
  belongs_to :user
  has_many :performances, dependent: :destroy
  validates :name, :unit, :target, :duration, {presence: true}

  before_save do |metric|
    metric.name = metric.name.downcase.titleize
  end

  before_save do |metric|
    metric.unit = metric.unit.downcase.titleize
  end

end
