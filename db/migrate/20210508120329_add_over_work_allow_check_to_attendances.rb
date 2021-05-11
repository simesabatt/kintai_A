class AddOverWorkAllowCheckToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_work_allow_check, :boolean
  end
end
