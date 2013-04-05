class VoteNotification < IdeaNotification

  def self.send_notification (user_sender, idea, users_receivers) 
    vote_notification = VoteNotification.create(user: user_sender, idea: idea, users: users_receivers)
  end

  def text
  	"Your idea " + Idea.find(self.idea_id).title.to_s() + " got a vote."
  end

  def link
    link_to "view idea", "idea#show"
  end

end
