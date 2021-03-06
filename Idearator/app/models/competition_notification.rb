class CompetitionNotification < ActiveRecord::Base
  inherits_from :notification

  belongs_to :user
  belongs_to :competition
  attr_accessible :type, :user,:competition, :users

  # creates new CompetitionNotification and pushes the notification to the online receivers
  # Params:
  # +user_sender+:: the parameter is an instance of +User+.
  # +competition+:: the parameter is an instance of +Competition+.
  # +users_receivers+:: the parameter is an array of instances of +User+.
  # Author: Amina Zoheir
  def self.send_notification(user_sender, competition, users_receivers)
  end

  # returns notification text
  # Params: none
  # Author: Amina Zoheir
  def text
  end

  # returns the value of the read field for a certain user and this notification
  # Params:
  # +user+:: the parameter is an instance of +User+.
  # Author: Amina Zoheir
  def read_by?(user)
    NotificationsUser.find(:first, :conditions => {notification_id: self.id, user_id: user.id }).read
  end

  # sets the value of the read field for a certain user and this notification to true
  # Params:
  # +user+:: the parameter is an instance of +User+.
  # Author: Amina Zoheir
  def set_read_for(user)
    notification = NotificationsUser.find(:first, :conditions => {notification_id: self.id, user_id: user.id})

    notification.read = true
    notification.save
  end

  def is_new(user)
    NotificationsUser.find(:first, :conditions => {notification_id: self.id, user_id: user.id }).new_notification
  end

  def set_old(user)
    notification = NotificationsUser.find(:first, :conditions => {notification_id: self.id, user_id: user.id})
    notification.new_notification = false
    notification.save
  end

end