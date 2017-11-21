class Performance < ApplicationRecord
  belongs_to :metric
  validates :date, :count, {presence: true}
  validates :count, numericality: { greater_than_or_equal_to: 0 }
end
