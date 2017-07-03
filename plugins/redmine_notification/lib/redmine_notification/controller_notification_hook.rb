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
          
          watchers = Watcher.where('watchable_type = ? and watchable_id = ?', 'Issue', context[:issue].id).select(:user_id)
            
          watchers.each do |watcher|
            IssueNotification.create(
                issue_id: context[:issue].id,
                user_id: watcher.user_id,
                journal_id: context[:issue].current_journal.id,
                updated_by: User.current.id,
                is_issue_new: is_issue_new ? true : false,
                is_new: true,
                is_viewed: false)
          end  
          
          if context[:issue].assigned_to.present?
            
            if context[:issue].assigned_to.type == 'Group'
              members = Group.where('id = ?', context[:issue].assigned_to.id).first.users.where('status = ?', 1).select(:id)
              
              members.each do |member|
                if !watchers.exists?(:user_id => member.id)
                  IssueNotification.create(
                      issue_id: context[:issue].id,
                      user_id: member.id,
                      journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
                      updated_by: User.current.id,
                      is_issue_new: is_issue_new ? true : false,
                      is_new: true,
                      is_viewed: false)
                end
              end
            elsif !watchers.exists?(:user_id => User.current.id)
              IssueNotification.create(
                issue_id: context[:issue].id,
                user_id: context[:issue].assigned_to.id,
                journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
                updated_by: User.current.id,
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