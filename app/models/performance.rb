class Performance < ApplicationRecord
  belongs_to :metric
  validates :date, :count, {presence: true}
end
