class Notify < ActiveRecord::Base
  belongs_to :user
  belongs_to :chat

  sync :all
  sync_scope :by_user, ->( user ) { where( user_id: user.id ) }
end
