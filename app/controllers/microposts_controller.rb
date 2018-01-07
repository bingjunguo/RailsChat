class MicropostsController < ApplicationController

	before_action :logged_in, only: [:create, :destroy]
end
