class HomesController < ApplicationController
  def home
  	@user = current_user
  	@micropost = current_user.microposts.build if logged_in?
  	@microposts = @user.microposts.paginate(page: params[:page]) if logged_in?
  end
end
