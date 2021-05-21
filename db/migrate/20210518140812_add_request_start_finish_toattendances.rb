class AddRequestStartFinishToattendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :request_start_at, :datetime
    add_column :attendances, :request_finish_at, :datetime
    add_column :attendances, :request_next_day, :boolean
  end
end
