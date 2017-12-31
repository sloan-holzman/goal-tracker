class Performance < ApplicationRecord
  belongs_to :metric
  validates :date, :count, {presence: true}
  validates :count, numericality: { greater_than_or_equal_to: 0 }

  def find_last_day_undone
    if self.date - self.metric.last_day_undone > 0
      if self.metric.good && self.count == 0 || !self.metric.good && self.count > 0
        self.metric.update(last_day_undone: self.date)
      end
    elsif self.date - self.metric.last_day_undone == 0
      if self.metric.good && self.count > 0 || !self.metric.good && self.count == 0
        duration = (self.date - self.metric.start_date).to_i
        (1..duration).each do |i|
          if (self.metric.good && self.metric.performances.find_by(date: (self.date - i)).count == 0) || (self.metric.good == false && self.metric.performances.find_by(date: (self.date - i)).count > 0)
            self.metric.update(last_day_undone: (self.date - i))
            break
          end
        self.metric.update(last_day_undone: (self.metric.start_date - 1))
        end
      end
    end
  end

  def update_weekly_total(old_count)
    week = self.metric.weeks.find_by(date: self.date.beginning_of_week(:sunday).to_date)
    new_total = week.total + (self.count - old_count)
    week.update(total: new_total)
  end


end
