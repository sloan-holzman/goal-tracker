class Performance < ApplicationRecord
  belongs_to :metric
  validates :date, :count, :entered, {presence: true}
end
