class Metric < ApplicationRecord
  belongs_to :user
  has_many :performances, dependent: :destroy
  has_many :weeks, -> { order(:date) }, dependent: :destroy
  validates :name, :unit, :target, :duration, {presence: true}

  before_save do |metric|
    metric.name = metric.name.downcase.titleize
    metric.unit = metric.unit.downcase.titleize
  end

  def metric_create_old_performances
    if Date.today >= self.start_date
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


  def create_past_weekly_totals
    if self.start_date <= Date.today
      date = self.start_date.beginning_of_week(:sunday)
      while date <= Date.today
        if !self.weeks.exists?(date: date)
          self.weeks.create(date: date, total: 0)
        end
        date += 7
      end
    end
  end

  def update_weekly_totals(original_start_date)
    if self.start_date < original_start_date
      week = self.start_date.beginning_of_week(:sunday)
      while week < original_start_date.beginning_of_week(:sunday)
        if !self.weeks.exists?(date: week)
          self.weeks.create(date: week, total: 0)
        end
        week += 7
      end
    end
    if original_start_date.to_date.beginning_of_week(:sunday) > self.start_date.beginning_of_week(:sunday)
      original_start_week = self.weeks.find_by(date: original_start_date.beginning_of_week(:sunday).to_date)
      if original_start_week
        original_start_week_total = self.performances.where("date >= ? and date < ?", original_start_date.beginning_of_week(:sunday), (original_start_date.beginning_of_week(:sunday)+7)).sum(:count)
        original_start_week.update(total: original_start_week_total)
      end
    end
    if self.start_date.beginning_of_week(:sunday).to_date <= Date.today
      start_week = self.weeks.find_by(date: self.start_date.beginning_of_week(:sunday).to_date)
      start_week_total = self.performances.where("date >= ? and date < ?", self.start_date, (self.start_date.beginning_of_week(:sunday)+7)).sum(:count)
      start_week.update(total: start_week_total)
    end
  end

  def create_missing_performances
    for metric in self.metrics
      date = Date.today
      while (date - metric.start_date).to_i >= 0
        if !metric.performances.exists?(date: date)
          metric.performances.create(date: date, count: 0, entered: false)
        end
        date -= 1
      end
    end
  end

end
