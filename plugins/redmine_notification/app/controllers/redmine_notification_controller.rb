class RedmineNotificationController < ApplicationController
  unloadable

  def index
    IssueNotification.where('user_id = ? and is_new = true', User.current.id).update_all(is_new: false)
    
    @notifications = IssueNotification.where('user_id = ? and is_viewed = false', User.current.id)
  end
  
  def mark_viewed
    #notification = IssueNotification.where('id = ? and user_id = ? and is_viewed = false', params[:id], User.current.id).update(is_viewed: true)
    
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js { render :layout => false }
    end
  end
  
  def mark_all_viewed
    #IssueNotification.where('user_id = ? and is_viewed = false', User.current.id).update_all(is_viewed: true)
    
    respond_to do |format|
      format.html { redirect_to :index }
      format.js { render :layout => false }
    end
  end

end
