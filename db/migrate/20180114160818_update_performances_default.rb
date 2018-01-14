class UpdatePerformancesDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:performances, :count, 0)
  end
end
