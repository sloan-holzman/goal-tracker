module CreatePerformances
  def create_old_performances
    if current_user.last_date_created < Date.today
      for metric in current_user.metrics
        date = (current_user.last_date_created + 1)
        while date <= Date.today
          metric.performances.find_or_create_by!(date: date)
          date+=1
        end
      end
    end
    current_user.update(last_date_created: Date.today)
  end
end
