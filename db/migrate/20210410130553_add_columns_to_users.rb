class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :integer
    add_column :users, :uid, :integer
    add_column :users, :work_now, :boolean
  end
end
