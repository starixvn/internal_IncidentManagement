class RedmineNotificationController < ApplicationController
  unloadable
  
  before_filter :find_journal, :only => [:diff]
  menu_item :issues

  def index
    IssueNotification.where('user_id = ? and is_new = true', User.current.id).update_all(is_new: false)
    
    notifications = IssueNotification.where('user_id = ?', User.current.id).order('is_viewed, updated_at DESC')
    
    respond_to do |format|
      format.html {
        @is_all_viewed = !notifications.exists?(:is_viewed => false)
    
        @notification_count = notifications.count
        @notification_pages = Paginator.new @notification_count, per_page_option, params['page']
        @notifications = notifications.limit(@notification_pages.per_page).offset(@notification_pages.offset)
      }
    end
  end
  
  def mark_viewed
    IssueNotification.where('id = ? and user_id = ? and is_viewed = false', params[:id], User.current.id).update_all(is_viewed: true)

    respond_to do |format|
      if params[:issue_id].present?
        format.html { redirect_to issue_path(params[:issue_id]) }
      else
        format.html { redirect_to :action => 'index' }
      end
    end
  end
  
  def mark_all_viewed
    IssueNotification.where('user_id = ? and is_viewed = false', User.current.id).update_all(is_viewed: true)
    
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
    end
  end
  
  def delete
    IssueNotification.where('id = ?', params[:id]).first.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
    end
  end
  
  def diff
    @issue = @journal.issue
    if params[:detail_id].present?
      @detail = @journal.details.find_by_id(params[:detail_id])
    else
      @detail = @journal.details.detect {|d| d.prop_key == 'description'}
    end
    (render_404; return false) unless @issue && @detail
    
    IssueNotification.where('id = ? and user_id = ? and is_viewed = false', params[:id], User.current.id).update_all(is_viewed: true)
    
    @diff = DiffHelper.new(@detail.value, @detail.old_value)
    @detail
  end
  
  private

  def find_journal
    @journal = Journal.visible.find(params[:journal_id])
    @project = @journal.journalized.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
