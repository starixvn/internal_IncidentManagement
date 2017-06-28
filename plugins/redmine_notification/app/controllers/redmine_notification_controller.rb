class RedmineNotificationController < ApplicationController
  unloadable

  def index
    IssueNotification.where('user_id = ? and is_new = true', User.current.id).update_all(is_new: false)
    
    @notifications = IssueNotification.where('user_id = ? and is_viewed = false', User.current.id)
  end

end
