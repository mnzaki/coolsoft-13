class DisapproveIdeaInCompetitionNotification < CompetitionIdeaNotification
  inherits_from :notification

  def self.send_notification (user_sender, idea, competition, users_receivers)
    disapprove_idea_in_competition_notification = DisapproveIdeaInCompetitionNotification.create(user: user_sender, idea: idea, competition: competition, users: users_receivers)
    user_ids = []
    users_receivers.each do |user|
      user_ids << user.id.to_s
    end
    NotificationsController::CoolsterPusher.new.push_notification user_ids, disapprove_idea_in_competition_notification
  end

  def text
    "Your idea " + Idea.find(self.idea_id).title + " wasn't approved in the competition " + Competition.find(self.competition_id).title + "."
  end

end