class Apply < ActiveRecord::Base
	belongs_to :user
  	belongs_to :app, :class_name => "User"
end
