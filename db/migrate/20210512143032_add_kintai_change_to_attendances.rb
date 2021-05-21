class AddKintaiChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :kintai_change_confirm, :integer
    add_column :attendances, :kintai_change_allow, :integer
    add_column :attendances, :kintai_change_allow_check, :boolean
    add_column :attendances, :kintai_month_confirm, :integer
    add_column :attendances, :kintai_month_allow, :integer
    add_column :attendances, :kintai_month_allow_check, :boolean
  end
end
