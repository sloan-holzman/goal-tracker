class Competition < ApplicationRecord
  belongs_to :group
  validates :end_date, presence: true, date: { after_or_equal_to:  :start_date}


  before_save do |competition|
    competition.metric_name = competition.metric_name.downcase.titleize
    competition.metric_unit = competition.metric_unit.downcase.titleize
  end


  def create_user_metrics
    for user in self.group.users
      metric = user.metrics.find_by(name: self.metric_name, unit: self.metric_unit)
      puts metric
      date = [Date.today, self.start_date].max
      if !metric
        user.metrics.create!(name: self.metric_name, unit: self.metric_unit, start_date: date, last_day_undone: date, last_week_undone: date.beginning_of_week(:sunday))
        user.seed_create_missing_performances
        user.seed_create_missing_weeks
      end
    end
  end

  def create_running_totals
    running_totals = []
    for user in self.group.users
      metric = user.metrics.find_by(name: self.metric_name, unit: self.metric_unit)
      if metric != nil
        running_total = metric.performances.where("date >= ? AND date <= ?", self.start_date, self.end_date).sum(:count)
        user_total = { name: "#{user.first_name} #{user.last_name}", total: running_total }
      else
        user_total = { name: "#{user.first_name} #{user.last_name}", total: 0 }
      end
      running_totals.push(user_total)
    end
    return running_totals.sort_by{|hash| hash[:total]}.reverse
  end



end
