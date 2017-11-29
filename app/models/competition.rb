class Competition < ApplicationRecord
  belongs_to :group

  before_save do |competition|
    competition.metric_name = competition.metric_name.downcase.titleize
  end

  before_save do |competition|
    competition.metric_unit = competition.metric_unit.downcase.titleize
  end

end
