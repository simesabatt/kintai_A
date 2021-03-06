class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :check ,:update_month_request]
  before_action :logged_in_user, only: [:show, :index, :edit, :destroy, :edit_basic_info, :update_basic_info, :update_month_request]
  before_action :admin_or_correct_user, only: [:update_month_request]
  before_action :correct_user, only: [:show]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show, :check]

  def index
    @users = User.paginate(page: params[:page]).order(:id)
    # @users = User.all
    if params[:name].present?
      @user = @users.get_by_name(params[:name])
    end
    if params[:id].present?
      @user = User.find_by(id: @users.id)
    else
      @user = User.new
    end
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    @superiors = User.where(superior: true).where.not(id: params[:id])
    @allow = Attendance.where(user_id: params[:id]).where(worked_on: @first_day)[0].kintai_month_allow
      respond_to do |format|
        format.html
        format.csv do
          attendance_csv
        end
      end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to users_url
    else
      render :new
    end
  end

  def edit
    @users = User.all
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_url
    else
       render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def import
    User.import(params[:file])
    redirect_to users_url
  end

  def employees_on_duty
    @users = User.all
  end

  def check
    @worked_sum = @attendances.where.not(started_at: nil).count
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    @superiors = User.where(superior: true).where.not(id: params[:id])
  end

  def update_month_request
    @attendance = Attendance.where(worked_on: params[:attendance][:month]).where(user_id: params[:id])
    @attendance[0][:kintai_month_confirm] = params[:attendance][:kintai_month_confirm]
    @attendance[0][:kintai_month_allow] = 1 # 申請中
    @attendance[0][:kintai_month_allow_check] = false
    if @attendance[0].save
      flash[:success] = "所属長承認申請を行いました。"
      redirect_to user_url(@user, date: params[:date])
    else
      flash[:danger] = "所属長承認申請に失敗しました。"
      redirect_to user_url(@user, date: params[:date])
    end
  end

  def kintai_log
    if params["log_date(1i)"].nil?
      search_date = Date.current.beginning_of_month      
    else
      date = params["log_date(1i)"].to_s + '-' + "%02d" % params["log_date(2i)"].to_s + '-01'
      search_date = Date.parse(date).beginning_of_month 
    end
    @attendances = Attendance.where(user_id: params[:id]).where(kintai_change_allow: 2).where(worked_on: search_date.in_time_zone.all_month).order(:worked_on)
    # debugger
    # redirect_to kintai_log_user_path(@attendances)
  end

  def update_kintai_log
    @attendances = Attendance.where(user_id: params[:id]).where(kintai_change_allow: 2).order(:worked_on)
    redirect_to kintai_log_user_path(@user)
    #render partial: "kintai_log"
  end

  private

    def attendance_csv
      csv_data = CSV.generate do |csv|
        csv_column_names = ["日付", "出社時間", "退勤時間"]
        csv << csv_column_names
          @attendances.each do |attendance|
          csv_column_values = [
            attendance.worked_on,
            attendance&.started_at&.strftime("%R"),
            attendance&.finished_at&.strftime("%R"),
          ]
          csv << csv_column_values
          end
      end
      send_data(csv_data,filename:"出退勤一覧.csv")
    end

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :employee_number, :uid, :basic_work_time, :designates_work_start_time, :designates_work_end_time)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :basic_work_time, :designates_work_start_time, :designates_work_end_time, :work_time, :uid, :employee_number, :password)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :basic_work_time, :designates_work_start_time, :designates_work_end_time, :work_time, :uid, :employee_number, :password)
    end

    def month_requset
      params.require(:attendance).permit(:kintai_month_confirm, :kintai_month_allow, :kintai_month_allow_check)
    end


    # beforeフィルター

    # # paramsハッシュからユーザーを取得します。
    # def set_user
    #   @user = User.find(params[:id])
    # end

    # # ログイン済みのユーザーか確認します。
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "ログインしてください。"
    #     redirect_to login_url
    #   end
    # end

    # # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    # def correct_user
    #   redirect_to(root_url) unless current_user?(@user)
    # end

    # # システム管理権限所有かどうか判定します。
    # def admin_user
    #   redirect_to root_url unless current_user.admin?
    # end
end