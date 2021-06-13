module AttendancesHelper

  def attendance_attend(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end

  def attendance_leave(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end

  # 時刻の時と分だけ取り出してint型に変換
  def int_time(datetime)
    return datetime.hour * 60 + datetime.min
  end

  # 時間表示に変換
  def hour_2f(int_time)
    format("%.2f", int_time / 60.0)
  end
end