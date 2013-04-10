
class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #username is unique
  validates :username, :uniqueness => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :body
  attr_accessible :email, :password, :password_confirmation, :remember_me, :date_of_birth, :type, :active , :first_name , :last_name , 
  :username , :date_of_birth , :gender , :about_me , :recieve_vote_notification , :provider, :uid, :recieve_comment_notification, :tags

  has_many :idea_notifications
  has_many :user_notifications
  has_many :ideas
  has_many :comments
  has_many :user_ratings
  has_and_belongs_to_many :idea_notifications
  has_and_belongs_to_many :user_notifications
  has_and_belongs_to_many :comments, :join_table => :likes
  has_and_belongs_to_many :ideas, :join_table => :votes
  has_many :authorizations

#this method compares the user's email with the one they log in with using Facebook
#for authorization and returns the user
#Params: auth, sign_in_resource=nil (not signed in)
#Author: Menna Amr
def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  unless user
    user = User.create(username:auth.extra.raw_info.username,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
                         )
  end
  user
  end
end

