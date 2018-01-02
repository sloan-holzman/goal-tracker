class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :metrics, -> { order(:start_date) }, dependent: :destroy
  has_many :performances, through: :metrics
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :requests, dependent: :destroy
  has_many :weeks, through: :metrics
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  before_save do |user|
    user.last_name = user.last_name.downcase.titleize
    user.first_name = user.first_name.downcase.titleize
  end


  def find_approval_requests
    admin_memberships = self.memberships.where(admin: true)
    groups = []
    for membership in admin_memberships
      groups.push(membership.group)
    end
    approval_requests = []
    for group in groups
      for request in group.requests
        approval_requests.push(request)
      end
    end
    return approval_requests
  end


  def find_reminder_frequency
    if !self.reminder
      reminder_frequency_message = "Off"
    elsif self.reminder_frequency == "Weekly"
      reminder_frequency_message = "Every #{self.reminder_day}"
    else self.reminder
      reminder_frequency_message = "Daily"
    end
    return reminder_frequency_message
  end


  def create_missing_weeks
    for metric in self.metrics
      date = Date.today.beginning_of_week(:sunday)
      while true
        if (date - metric.start_date.beginning_of_week(:sunday)).to_i >= 0

          if !metric.weeks.exists?(date: date)
            weekly_total = metric.performances.where("date >= ? and date <= ?", date, (date+6)).sum(:count)
            puts "date: #{date}"
            puts "weekly_total: #{weekly_total}"
            metric.weeks.create(date: date, total: weekly_total)
          end

          date -= 7
        else
          break
        end
      end
    end
  end

  def create_missing_performances
    for metric in self.metrics
      date = Date.today
      while true
        if (date - metric.start_date).to_i >= 0
          if !metric.performances.exists?(date: date)
            puts "performance - date: #{date} metric: #{metric.name}"
            metric.performances.create(date: date, count: 0, entered: false)
          end
          date -= 1
        else
          break
        end
      end
    end
  end

  def create_array_of_weeks
    start_dates = self.metrics.map do |metric|
      metric.start_date
    end
    start = [start_dates.min.beginning_of_week(:sunday),(Date.today - 63).beginning_of_week(:sunday)].max
    last = Date.today.end_of_week(:saturday)
    weeks = []
    week = start
    while week <= last
      weeks.push(week)
      week +=7
    end
    return weeks
  end



  def create_metric_table
    table_array = []
    table_array[0] = {column1: "Metric", column2: "Weekly Goal", column3: "Start Date", values: self.create_array_of_weeks}


    self.metrics.each do |metric|




      return {column1: `#{metric.name}`, column2: `#{metric.target} #{metric.unit}`, column3: `#{metric.start_date}`, values: weekly_total_array}





    end


    <% for metric in @metrics %>
        <% ordered_weeks = metric.weeks.where("date >= ?", metric.start_date.beginning_of_week(:sunday))%> <%#this would a goodp place to use an AR scope %>
        <% if ordered_weeks.length > 0 %>
          <% if (@dates[0] - ordered_weeks[0]["date"].beginning_of_week(:sunday)).to_i >= 0 %>
            <% week_index = 0 %>
            <% for week in ordered_weeks%>
              <% if week.date - @dates[0] == 0 %>
                <% break %>
              <% else %>
                <% week_index += 1 %>
              <% end %>
            <% end %>
            <% week_count = 0 %>
            <% until week_count >= (@dates.length+week_index) do %>
              <% if week_count >= week_index %>
                <% if metric.good %>
                  <td class=<%= ordered_weeks[week_count]["total"] >= metric.target ? "metric-table__hit" : "metric-table__missed" %>><%= ordered_weeks[week_count]["total"] %></td>
                <% else %>
                  <td class=<%= ordered_weeks[week_count]["total"] <= metric.target ? "metric-table__hit" : "metric-table__missed" %>><%= ordered_weeks[week_count]["total"] %></td>
                <% end %>
              <% end %>
              <% week_count +=1 %>
            <% end %>
          <% else %>
            <% week_count = 0 %>
            <% date_count = 0 %>
            <% until date_count >= (@dates.length) do %>
              <% if (ordered_weeks[week_count]["date"] - @dates[date_count]).to_i <= 0 %>
                  <% if metric.good %>
                    <td class=<%= ordered_weeks[week_count]["total"] >= metric.target ? "metric-table__hit" : "metric-table__missed" %>><%= ordered_weeks[week_count]["total"] %></td>
                  <% else %>
                    <td class=<%= ordered_weeks[week_count]["total"] <= metric.target ? "metric-table__hit" : "metric-table__missed" %>><%= ordered_weeks[week_count]["total"] %></td>
                  <% end %>
                  <% week_count += 1 %>
              <% else %>
                <td class="metric-table__prior"></td>
              <% end %>
              <% date_count += 1 %>
            <% end %>
          <% end  %>
        <% else %>
          <% date_count = 0 %>
          <% until date_count >= (@dates.length) do %>
              <td class="metric-table__prior"></td>
              <% date_count += 1 %>
          <% end %>
        <% end %>
      </tr>
    <% end %>
    </table>
  end

























end
