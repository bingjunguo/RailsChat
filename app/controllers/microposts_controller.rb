class MicropostsController < ApplicationController

	before_action :logged_in, only: [:create, :destroy]

	def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "微博建立成功!"
      redirect_to root_url
    else
    	flash[:warning] = "未发布"
      redirect_to root_url
    end
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
end
