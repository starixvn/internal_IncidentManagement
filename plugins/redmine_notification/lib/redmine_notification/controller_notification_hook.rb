module RedmineNotification
  module Hooks
    class ControllerNotificationHook < Redmine::Hook::ViewListener
      
      def controller_issues_edit_after_save(context={})        
        save_notification_to_issue(context)
        context[:issue].save
      end

      def controller_issues_new_after_save(context={})
        save_notification_to_issue(context)
        context[:issue].save
      end
      
    private
      def save_notification_to_issue(context)
        params = context[:params]
        if params && params[:issue]
          #if User.current.allowed_to?(:edit_issues, context[:issue].project)            
          #end
          
          #context[:issue].current_journal.details
          
          #IssueNotification.create(issue_id: 1, user_id: 1, journal_id: 1, is_new: 0, is_viewed: 0)
        end
      end

    end
  end
end