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

  has_many :idea_notifications
  has_many :user_notifications
  has_many :ideas
  has_many :comments
  has_many :user_ratings
  has_many :idea_notifications_users
  has_many :idea_notifications, :through => :idea_notifications_users
  has_many :user_notifications_users
  has_many :user_notifications, :through => :user_notifications_users
  has_and_belongs_to_many :comments, :join_table => :likes
  has_and_belongs_to_many :ideas, :join_table => :votes

end
