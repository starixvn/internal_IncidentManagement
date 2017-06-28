class RedmineNotificationController < ApplicationController
  unloadable

  def index
    @notifications = IssueNotification.where('user_id = ? and is_viewed = false', User.current.id)
  end

end
