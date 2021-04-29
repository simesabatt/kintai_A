require 'csv'
require 'date'

CSV.generate do |csv|
  csv_column_names = %w(worked_on started_at finished_at user_id)
  csv << csv_column_names
  @attendances.each do |a|
    csv_column_values = [
      a.worked_on,
      a&.started_at&.strftime("%H:%M"),
      a&.finished_at&.strftime("%H:%M"),
      a.user_id
    ]
    csv << csv_column_values
  end
end