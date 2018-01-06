class AppliesController < ApplicationController
  include SessionsHelper
  before_action :logged_in

  #before_action :set_apply, only: [:show, :edit, :update, :destroy]

  # POST /applies
  # POST /applies.json
  def create
    @apply = current_user.applies.build(:friend_id => params[:friend_id])
    if @apply.save
      flash[:info] = "发送好友申请成功"
      redirect_to chats_path
    else
      flash[:error] = "发送好友申请失败"
      redirect_to chats_path
    end
  end

  def destroy
    @apply = current_user.applies.find_by(friend_id: params[:id])
    @apply.destroy

    user=User.find_by_id(params[:id])
    current_user.chats.each do |chat|
      if (chat.users-[user, current_user]).blank?
        chat.destroy
      end
    end

    #flash[:success] = "删除好友成功"
    #redirect_to chats_path
  end

  private
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end
end
