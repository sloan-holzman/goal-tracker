class Competition < ApplicationRecord
  belongs_to :group

  before_save do |competition|
    competition.metric_name = competition.metric_name.downcase.titleize
    competition.metric_unit = competition.metric_unit.downcase.titleize
  end


  def create_user_metrics
    for user in self.group.users
      user.metrics.find_or_create_by!(name: self.metric_name, unit: self.metric_unit)
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
