class FriendshipsController < ApplicationController
  include SessionsHelper
  before_action :logged_in

  def create
    #Apply.where("applies.user_id=1 and applies.friend_id= 20")

 #   a = Apply.where("applies.user_id = 1 and applies.friend_id=20")
  #Apply Load (0.4ms)  SELECT "applies".* FROM "applies" WHERE (applies.user_id = 1 and applies.friend_id=20)
 #=> #<ActiveRecord::Relation [#<Apply id: 9, user_id: 1, friend_id: 20, created_at: "2018-01-08 06:37:59", updated_at: "2018-01-08 06:37:59">]> 
#2.2.4 :019 > b = Apply.find(9)
 # Apply Load (0.2ms)  SELECT  "applies".* FROM "applies" WHERE "applies"."id" = ? LIMIT 1  [["id", 9]]
 #=> #<Apply id: 9, user_id: 1, friend_id: 20, created_at: "2018-01-08 06:37:59", updated_at: "2018-01-08 06:37:59"> 
#2.2.4 :020 > b.destroy
 #  (0.2ms)  begin transaction
  #SQL (0.5ms)  DELETE FROM "applies" WHERE "applies"."id" = ?  [["id", 9]]
   #(111.0ms)  commit transaction
 #<Apply id: 9, user_id: 1, friend_id: 20, created_at: "2018-01-08 06:37:59", updated_at: "2018-01-08 06:37:59"> 
    
    apply = Apply.where("applies.user_id = #{params[:friend_id]} and applies.friend_id = #{current_user.id}")
    a = apply.as_json
    b = a[0]
    c = b["id"]
    del = Apply.find(c)
    #@apply = current_user.applies.find_by(friend_id: params[:friend_id], user_id: current_user.id)
    if del.destroy
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
      if @friendship.save
        flash[:info] = "添加好友成功"
        redirect_to chats_path
      end
    else
      flash[:error] = "无法添加好友"
      redirect_to chats_path
    end
  end

  def destroy
    @friendship = current_user.friendships.find_by(friend_id: params[:id])
    @friendship.destroy

    user=User.find_by_id(params[:id])
    current_user.chats.each do |chat|
      if (chat.users-[user, current_user]).blank?
        chat.destroy
      end
    end

    flash[:success] = "删除好友成功"
    redirect_to chats_path
  end

  private
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

end
