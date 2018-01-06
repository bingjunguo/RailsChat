class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? #&& user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      # log_in user
      flash[:success] = "激活成功，请登录"
      redirect_to root_url
    else
      flash[:danger] = "链接无效，激活失败"
      redirect_to root_url
    end
  end
end
