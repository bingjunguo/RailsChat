class User < ActiveRecord::Base

  has_many :messages
  has_and_belongs_to_many :chats

  has_many :friendships
  has_many :applies

  has_many :apps, :through => :applies
  has_many :friends, :through => :friendships

  has_many :inverse_applies, :class_name => "Apply", :foreign_key => "friend_id"  
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  has_many :inverse_apps, :through => :inverse_applies, :source => :user
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  before_save :downcase_email
  attr_accessor :remember_token
  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  #1. The ability to save a securely hashed password_digest attribute to the database
  #2. A pair of virtual attributes (password and password_confirmation), including presence validations upon object creation and a validation requiring that they match
  #3. An authenticate method that returns the user when the password is correct (and false otherwise)
  has_secure_password
  # has_secure_password automatically adds an authenticate method to the corresponding model objects.
  # This method determines if a given password is valid for a particular user by computing its digest and comparing the result to password_digest in the database.

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  def self.filter_by_type(type)
    User.where("role = :type", type: type)
  end

  def self.none_hidden_users
    User.where("hidden = :type", type: false)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def user_remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def user_forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def user_authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  def self.search(params)
    User.where("users.name LIKE ?", "%#{params[:query]}%")
  end

  def self.search_friends(params, current_user)
    User.all_except(current_user).all_except(current_user.friends).where("users.name LIKE ?", "%#{params[:query]}%")
  end

  def self.search_new_friends(params, current_user)
    friend_ids = Apply.where("applies.friend_id = ?", "#{current_user.id}")
    #User.where("users.name IN ?", friends)
    friends_info = Array.new
    for friend in friend_ids
      friends_info += User.where("users.id = ?", "#{friend.user_id}")
    end
    return friends_info
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def self.all_except(user)
    where.not(id: user)
  end

end
