class UsersController < ApplicationController
  include SessionsHelper
  before_action :set_user, except: [:index, :new, :index_json]
  before_action :logged_in, only: [:show]
  before_action :correct_user, only: :show

  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      # @user.create_salary
      # @user.create_performance
      redirect_to root_path, flash: {success: "注册成功"}
    else
      flash[:warning] = "注册信息填写有误,请重试"
      render 'new'
    end
  end

  def show

    @user = User.find(params[:id])
  end

  def edit
    # 在tutorial中，有如下两句话，在此处并不适用correct_user 中定义了 @user 变量，
    # 所以可以把 edit 和 update 动作中的 @user 赋值语句删掉。
    # 注意，上面那两句花呗是错误的！
    @user = User.find(params[:id])
  end

  # def update
  #   if @user.update_attributes(user_params)
  #     flash={:info => "更新成功"}
  #   else
  #     flash={:warning => "更新失败"}
  #   end
  #   redirect_to users_path, flash: flash
  # end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy
    @user.destroy
    redirect_to users_path(new: false), flash: {success: "用户删除"}
  end

  def index
    @users=User.search(params).paginate(:page => params[:page], :per_page => 10)
  end

  def index_json
    @users=User.search_friends(params, current_user)
    render json: @users.as_json
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :sex, :department_id, :password,
                                 :password_confirmation, :phonenumber, :status)
  end

# Confirms a logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def correct_user
    # unless current_user == @user or current_user.role == 5
    #   redirect_to user_path(current_user), flash: {:danger => '您没有权限浏览他人信息'}
    # end
  end

  def set_user
    # guo 注释掉了这些
    # @user=User.find_by_id(params[:id])
    # if @user.nil?
    #   redirect_to root_path, flash: {:danger => '没有找到此用户'}
    # end
  end

end
