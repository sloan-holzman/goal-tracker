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

  def update_last_date_entered(performance)
    if (performance.date - self.last_date_entered).to_i > 0
      self.update(last_date_entered: performance.date)
    end
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
    else
      reminder_frequency_message = "Daily"
    end
    return reminder_frequency_message
  end


  def seed_create_missing_weeks
    for metric in self.metrics
      date = Date.today.beginning_of_week(:sunday)
      while (date - metric.start_date.beginning_of_week(:sunday)).to_i >= 0
        if !metric.weeks.exists?(date: date)
          weekly_total = metric.performances.where("date >= ? and date <= ?", date, (date+6)).sum(:count)
          puts "date: #{date}"
          puts "weekly_total: #{weekly_total}"
          metric.weeks.create(date: date, total: weekly_total)
        end
        date -= 7
      end
    end
  end

  def seed_create_missing_performances
    for metric in self.metrics
      date = Date.today
      while date > metric.start_date
      # while (date - metric.start_date).to_i >= 0
        if !metric.performances.exists?(date: date)
          puts "performance - date: #{date} metric: #{metric.name}"
          metric.performances.create(date: date, count: 0, entered: false)
        end
        date -= 1
      end
    end
  end

  def create_missing_weeks
    date = Date.today.beginning_of_week(:sunday)
    while self.last_date_created < date
      for metric in self.metrics
        metric.weeks.find_or_create_by(date: date)
      end
      date -= 7
    end
  end


  def create_array_of_weeks
    start_dates = self.metrics.map do |metric|
      metric.start_date
    end
    start = [start_dates.min.beginning_of_week(:sunday),(Date.today - 63).beginning_of_week(:sunday)].max
    last = Date.today.saturday? ? Date.today : Date.today.end_of_week(:saturday)
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
    table_array[0] = {column1: "Metric", column2: "Weekly Goal", column3: "Start Date", dates: self.create_array_of_weeks}
    dates = self.create_array_of_weeks
    self.create_missing_weeks
    self.metrics.each do |metric|
      weekly_total_array = []
      ordered_weeks = metric.weeks.where("date >= ? and date<=?", metric.start_date.beginning_of_week(:sunday),Date.today.end_of_week(:saturday))
      if ordered_weeks.length > 0
        if (dates[0] - ordered_weeks[0]["date"].beginning_of_week(:sunday)).to_i >= 0
          week_index = 0
          for week in ordered_weeks
            if week.date - dates[0] == 0
              break
            else
              week_index += 1
            end
          end
          week_count = 0
          until week_count >= (dates.length+week_index) do
            if week_count >= week_index
                weekly_total_array.push(ordered_weeks[week_count]["total"])
            end
            week_count +=1
          end
        else
          week_count = 0
          date_count = 0
          until date_count >= (dates.length) do
            if (ordered_weeks[week_count]["date"] - dates[date_count]).to_i <= 0
                weekly_total_array.push(ordered_weeks[week_count]["total"])
                week_count += 1
            else
              weekly_total_array.push("prior")
            end
            date_count += 1
          end
        end
      else
        date_count = 0
        until date_count >= (dates.length) do
            weekly_total_array.push("prior")
            date_count += 1
        end
      end
      table_array.push({metric: metric, values: weekly_total_array})
    end
    puts table_array
    return table_array
  end


end
