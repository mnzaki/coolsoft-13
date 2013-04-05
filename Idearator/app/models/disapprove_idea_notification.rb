class DisapproveIdeaNotification < IdeaNotification

  def self.send_notification(user_sender, idea, users_receivers) 
    disapprove_notification = DisapproveIdeaNotification.create(user: user_sender, idea: idea, users: users_receivers)
  end

  def text
    return "Your " + Idea.find(self.idea_id).title.to_s() + " wasn't approved by the committee."
  end

  def link
    link_to "view idea", "idea#show"
  end

end