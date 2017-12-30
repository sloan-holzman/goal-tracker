class Metric < ApplicationRecord
  belongs_to :user
  has_many :performances, dependent: :destroy
  validates :name, :unit, :target, :duration, {presence: true}

  before_save do |metric|
    metric.name = metric.name.downcase.titleize
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


  def find_last_day_undone
    if self.last_day_undone - self.start_date >= 0
      if self.good && self.performances.find_by(date: self.last_day_undone.to_date).count > 0 || !self.good && self.performances.find_by(date: self.last_day_undone.to_date).count == 0
        duration = (self.last_day_undone - self.metric.start_date).to_i
        (1..duration).each do |i|
          if (self.good && self.performances.find_by(date: (self.last_day_undone - i)).count == 0) || (self.good == false && self.performances.find_by(date: (self.last_day_undone - i)).count > 0)
            self.update(last_day_undone: (self.last_day_undone - i))
            break
          end
        self.update(last_day_undone: (self.start_date - 1))
        end
      end
    end
  end


end
