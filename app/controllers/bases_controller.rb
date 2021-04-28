class BasesController < ApplicationController
  def index
    @bases = Base.all
    @base = Base.new
  end

  def show
    @base = Base.find(params[:id])
  end
  
  def new
    @base = Base.new
  end

  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to bases_url
    else
      render :new
    end
  end

  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点の更新に成功しました。"
      redirect_to bases_url
    else
      render :edit
    end
  end

  def edit
    @base = Base.find(params[:id])
  end
  
  def destroy
    @base = Base.find(params[:id])
    flash[:success] = "#{@base.base_name}のデータを削除しました。"
    @base.destroy
    redirect_to bases_url
  end

  private
    
    def base_params
      params.require(:base).permit(:base_num, :base_name, :base_type, :user_id)
    end

end
