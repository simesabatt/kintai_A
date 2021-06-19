class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :request_finish_at_is_invalid_without_a_request_start_at
  # 退勤時間が存在しない場合、出勤時間は無効
  validate :request_start_at_is_invalid_without_a_request_finish_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :request_start_at_than_request_finish_at_fast_if_invalid

  def request_finish_at_is_invalid_without_a_request_start_at
    if request_start_at.blank? && request_finish_at.present?
      errors.add(:request_start_at, "が必要です")
    end
  end
  
  def request_start_at_is_invalid_without_a_request_finish_at
    if request_start_at.present? && request_finish_at.blank?
    # if (Date.current != worked_on ) && request_start_at.present? && request_finish_at.blank?
      errors.add(:request_finish_at, "が必要です")
    end
  end

  def request_start_at_than_request_finish_at_fast_if_invalid
    if request_start_at.present? && request_finish_at.present?
      unless kintai_change_next_day == true
        errors.add(:request_start_at, "より早い退勤時間は無効です") if request_start_at > request_finish_at || kintai_change_next_day == true
      end
    end
  end
end