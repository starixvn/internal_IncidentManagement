module RedmineNotification
  module Hooks
    class ControllerNotificationHook < Redmine::Hook::ViewListener

      def controller_issues_new_after_save(context={})
        save_notification_to_issue(context, true)
        context[:issue].save
      end
      
      def controller_issues_edit_after_save(context={})        
        save_notification_to_issue(context, false)
        context[:issue].save
      end
      
    private
      def save_notification_to_issue(context, is_issue_new)
        params = context[:params]
        if params && params[:issue] && context[:issue] && context[:issue].id.present?
          
          issue_id = context[:issue].id
          watchers = Watcher.where('watchable_type = ? and watchable_id = ?', 'Issue', issue_id).select(:user_id)
            
          watchers.each do |watcher|
            IssueNotification.create(
                issue_id: issue_id,
                user_id: watcher.user_id,
                journal_id: context[:issue].current_journal.id,
                updated_by: User.current.id,
                updated_at: Time.now,
                is_issue_new: is_issue_new ? true : false,
                is_new: true,
                is_viewed: false)
          end  
          
          if context[:issue].assigned_to.present?
            assigned_id = context[:issue].assigned_to.id
            
            if context[:issue].assigned_to.type == 'Group'
              members = Group.where('id = ?', assigned_id).first.users.where('status = ?', 1).select(:id)
              
              members.each do |member|
                if !watchers.exists?(:user_id => member.id)
                  IssueNotification.create(
                      issue_id: issue_id,
                      user_id: member.id,
                      journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
                      updated_by: User.current.id,
                      updated_at: Time.now,
                      is_issue_new: is_issue_new ? true : false,
                      is_new: true,
                      is_viewed: false)
                end
              end
            elsif context[:issue].assigned_to.type == 'User' && !watchers.exists?(:user_id => assigned_id)
              IssueNotification.create(
                issue_id: issue_id,
                user_id: assigned_id,
                journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
                updated_by: User.current.id,
                updated_at: Time.now,
                is_issue_new: is_issue_new ? true : false,
                is_new: true,
                is_viewed: false)
            end
            
          end
        end
      end

    end
  end
end