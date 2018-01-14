class UpdateWeeksDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:weeks, :total, 0)
  end
end
