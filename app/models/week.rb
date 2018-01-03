class Week < ApplicationRecord
  belongs_to :metric
  validates :date, :total, {presence: true}
  validates :total, numericality: { greater_than_or_equal_to: 0 }
end
