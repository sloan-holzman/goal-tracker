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

  def create_old_performances
    if Date.today > self.start_date
      (self.start_date..Date.today).each do |date|
        if !self.performances.exists?(date: date)
          self.performances.create!(count: 0, date: date, entered: false)
        end
      end
    end
  end

  def delete_prestart_unentered_performances
    for performance in self.performances
      if performance.date < self.start_date && performance.entered == false
        performance.destroy!
      end
    end
  end



end
