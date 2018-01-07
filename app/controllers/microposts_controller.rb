class MicropostsController < ApplicationController

	before_action :logged_in, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy

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
  	@micropost.destroy
    flash[:success] = "微博删除成功"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
      
    end

    
    def correct_user
    	if current_user.admin?
    		@micropost = Micropost.find_by(id: params[:id])
    	else

      	@micropost = current_user.microposts.find_by(id: params[:id])
      end 
      redirect_to root_url if @micropost.nil?
    end
end
