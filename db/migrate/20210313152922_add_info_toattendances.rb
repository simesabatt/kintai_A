class AddInfoToattendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_request, :datetime, default: Time.current.change(hour: 9, min: 0, sec: 0)

  end
end
