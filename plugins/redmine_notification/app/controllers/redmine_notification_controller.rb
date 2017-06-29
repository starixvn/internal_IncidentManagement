class RedmineNotificationController < ApplicationController
  unloadable

  def index
    IssueNotification.where('user_id = ? and is_new = true', User.current.id).update_all(is_new: false)
    
    @notifications = IssueNotification.where('user_id = ? and is_viewed = false', User.current.id)
  end
  
  def mark_viewed
    IssueNotification.where('id = ? and user_id = ? and is_viewed = false', params[:issue_notification][:id], User.current.id).update(is_viewed: true)

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
    end
  end
  
  def mark_all_viewed
    IssueNotification.where('user_id = ? and is_viewed = false', User.current.id).update_all(is_viewed: true)
    
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
    end
  end
  
  def diff
    
  end

end
