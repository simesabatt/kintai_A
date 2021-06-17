class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
        @user.update_attributes(work_now: true)
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
        @user.update_attributes(work_now: false)
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        if item["kintai_change_confirm"].present?
            if item["request_next_day"] == "true"
            #  debugger
            #   item["request_finish_at"] = (item["request_finish_at"].to_time + 60 * 60 * 24).to_s
            #   debugger 
              #.to_time.strftime("%T.%L") 
            end
          attendance = Attendance.find(id)
          item[:kintai_change_allow] = 1 # 申請中フラグ
          attendance.kintai_change_allow_check = false
          attendance.update_attributes!(item) # !は例外処理
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def overtime_request
  end

  def edit_overwork_request
    # @attendance = Attendance.find(params[:id])↓これでも良い
    @attendance = User.find(params[:user_id]).attendances.find(params[:id]).order(:id)
    @user = User.find(@attendance.user_id).order(:id)
  end

  def update_overwork_request
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
    if params[:attendance][:next_day] == "true"
      params[:attendance]["overwork_request(3i)"] = (params[:attendance]["overwork_request(3i)"].to_i+1).to_s
    else
      if params[:attendance]["overwork_request(4i)"].to_i*60 + params[:attendance]["overwork_request(5i)"].to_i < User.find(params[:user_id]).designates_work_end_time.hour * 60 + User.find(params[:user_id]).designates_work_end_time.min
        flash[:danger] = "残業は指定勤務終了時間より後の時間で設定してください。<br>" + @user.errors.full_messages.join("</br>")
        redirect_to @user and return
      end
    end
    if @attendance.update_attributes(overwork_request_params)
      @attendance.over_work_allow = 1 # 申請中フラグ
      @attendance.over_work_allow_check = false
      @attendance.save
      flash[:success] = "残業の申請に成功しました。"
    else
      flash[:danger] = "残業の申請に失敗しました。<br>" + @user.errors.full_messages.join("</br>")
    end
    redirect_to @user
  end

  def edit_overwork_request_confirm
    @user = User.find(params[:user_id])
    @attendances = Attendance.where(superior_confirm: @user.id, over_work_allow: 1).order(:user_id).group_by(&:user_id)
  end

  def update_overwork_request_confirm
    @user = User.find(params[:user_id])
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      overwork_allow_update.each do |id, item|
        if item["over_work_allow_check"] == "true"
          attendance = Attendance.find(id)
          attendance.update_attributes!(item) # !は例外処理
        else
          attendance = Attendance.find(id)
          attendance.save
        end
      end
    end
    flash[:success] = "残業申請を更新しました"
    redirect_to user_url(@user, date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
  flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
  redirect_to user_url(@user, date: params[:date])
  end

  def edit_kintai_change_confirm
    @user = User.find(params[:user_id])
    @attendances = Attendance.where(kintai_change_confirm: @user.id, kintai_change_allow: 1).order(:user_id).group_by(&:user_id)
  end

  def update_kintai_change_confirm
    @user = User.find(params[:user_id])
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      change_allow_update.each do |id, item|
        if item["kintai_change_allow_check"] == "true" 
          if item["kintai_change_allow"] == "2" # 承認
            attendance = Attendance.find(id)
            attendance.update_attributes!(before_start_at: Attendance.find(id).started_at,
                                         before_finish_at: Attendance.find(id).finished_at, started_at: Attendance.find(id).request_start_at, finished_at: Attendance.find(id).request_finish_at,
                                         next_day: Attendance.find(id).request_next_day)
            attendance.update_attributes!(item)
          elsif item["kintai_change_allow"] == "3" # 否認
            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
          else
          end
        else
          item["kintai_change_allow_check"] == "false"
          attendance = Attendance.find(id)
          attendance.save
        end
      end
    end
      flash[:success] = "残業申請を更新しました"
      redirect_to user_url(@user, date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to user_url(@user, date: params[:date])
  end

  def edit_month_change_confirm
    @user = User.find(params[:user_id])
    @attendances = Attendance.where(kintai_month_confirm: @user.id, kintai_month_allow: 1).order(:user_id).group_by(&:user_id)
  end

  def update_month_change_confirm
    @user = User.find(params[:user_id])
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      month_allow_update.each do |id, item|
        if item["kintai_month_allow_check"] == "true" 
          if item["kintai_month_allow"] == "2" # 承認
            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
          elsif item["kintai_month_allow"] == "3" # 否認
            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
          else
          end
        else
          item["kintai_month_allow_check"] == "false"
          attendance = Attendance.find(id)
          attendance.save
        end
      end
    end
      flash[:success] = "1ヶ月分の勤怠申請を更新しました。"
      redirect_to user_url(@user, date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "1ヶ月分の勤怠申請に無効な入力データがあります。"
    redirect_to user_url(@user, date: params[:date])
  end

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.permit(attendances: [:started_at, :finished_at, :note, :kintai_change_confirm, :kintai_change_allow, :kintai_change_allow_check, :request_start_at, :request_finish_at, :request_next_day])[:attendances]
    end

    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end

    # 残業申請モーダル
    def overwork_request_params
      params.require(:attendance).permit(:overwork_request, :next_day, :work_content, :superior_confirm, :over_work_allow_check)
    end

    # 残業承認
    def overwork_allow_update
      params.permit(attends: [:over_work_allow, :over_work_allow_check])[:attends]
    end

    # 勤怠変更承認
    def change_allow_update
      params.permit(attends: [:started_at, :finished_at, :request_start_at, :request_finish_at, :kintai_change_allow_check, :kintai_change_allow, :before_start_at, :before_finish_at, :before_next_day])[:attends]
    end

    # 1ヶ月の勤怠申請承認
    def month_allow_update
      params.permit(attends: [:kintai_month_allow_check, :kintai_month_allow])[:attends]
    end
end