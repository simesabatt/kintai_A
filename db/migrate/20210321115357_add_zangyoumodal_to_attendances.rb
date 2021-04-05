class AddZangyoumodalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day, :boolean
    add_column :attendances, :work_content, :text
    add_column :attendances, :superior_confirm, :integer
  end
end
