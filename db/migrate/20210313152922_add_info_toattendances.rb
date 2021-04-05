class AddInfoToattendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overwork_request, :datetime
  end
end
