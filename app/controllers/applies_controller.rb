class AppliesController < ApplicationController
  include SessionsHelper
  before_action :logged_in

  #before_action :set_apply, only: [:destroy]

  def index
    @applies = Apply.all

  end

  # POST /applies
  # POST /applies.json
  def create
    count = Apply.where("applies.user_id = #{current_user.id} and applies.friend_id = #{params[:friend_id]}")
    if (count != nil && count.as_json.length >= 1) || (current_user.id == params[:friend_id])
      flash[:error] = "发送好友申请失败"
      redirect_to chats_path
    else
      @apply = current_user.applies.build(:friend_id => params[:friend_id])
      if @apply.save
        flash[:info] = "发送好友申请成功"
        redirect_to chats_path
      else
        flash[:error] = "发送好友申请失败"
        redirect_to chats_path
      end
    end
  end

  def destroy
    @apply = current_user.applies.find_by(friend_id: params[:id])
    @apply.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
   # def set_apply
    #  @apply = Apply.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def apply_params
     # params.require(:apply).permit(:user_id, :friend_id)

    def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end
end
