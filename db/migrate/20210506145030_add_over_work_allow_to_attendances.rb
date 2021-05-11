class AddOverWorkAllowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_work_allow, :integer
  end
end
