class Comment < ActiveRecord::Base
  attr_accessible :content

  belongs_to :idea
  belongs_to :user
  has_and_belongs_to_many :users, join_table: :likes
end