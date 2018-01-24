module GraphMaker

  def create_data_for_current_week_graph(metrics)

    # array containing the weekly goal/target for each metric
    target_data = []
    for metric in metrics
      array = [metric.name, metric.target]
      target_data.push(array)
    end

    # array containing the current week's total for each metric
    actual_data = metrics.map do |metric|
      [metric.name, metric.weeks.find_or_create_by(date: Date.today.beginning_of_week(:sunday)).total]
    end

    # data organized in a manner that the chartkick gem can handle to produce bar charts for each metric's weekly total against the weekly goal
    return [{name: "Weekly Goal",data: target_data},{name: "Count so far",data: actual_data}]
  end


end
