class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :date_of_birth, :type, :active , :first_name , :last_name , 
  :username , :date_of_birth , :gender , :about_me , :recieve_vote_notification , 
  :recieve_comment_notification

  has_many :action_notifications
  has_many :ideas
  has_many :comments
  has_many :user_ratings
  has_and_belongs_to_many :notifications
  has_and_belongs_to_many :comments, :join_table => :likes
  has_and_belongs_to_many :ideas, :join_table => :votes

  # Devise uses this to check if a User is active
  def active?
    super and self.active
  end

end
