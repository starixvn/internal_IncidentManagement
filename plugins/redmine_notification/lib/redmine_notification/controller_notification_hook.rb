module RedmineNotification
  module Hooks
    class ControllerNotificationHook < Redmine::Hook::ViewListener

      def controller_issues_new_after_save(context={})
        save_notification_to_issue(context, true)
        # context[:issue].save
      end
      
      def controller_issues_edit_after_save(context={})        
        save_notification_to_issue(context, false)
        # context[:issue].save
      end
      
    private
      def save_notification_to_issue(context, is_issue_new)
        params = context[:params]
        if params && params[:issue] && context[:issue] && context[:issue].id.present?
          
          issue_id = context[:issue].id
          current_user_id = User.current.id
          user_ids = []
          
          if !Setting.plugin_redmine_notification[:notification_to_creator].blank?
            user_ids.push(context[:issue].author.id)
            
            IssueNotification.create(
              issue_id: issue_id,
              user_id: context[:issue].author.id,
              journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
              updated_by: current_user_id,
              updated_at: Time.now,
              is_issue_new: is_issue_new ? true : false,
              is_new: true,
              is_viewed: false)
          end
          
          if !Setting.plugin_redmine_notification[:notification_to_modifier].blank? && !user_ids.include?(current_user_id)
            user_ids.push(current_user_id)
            
            IssueNotification.create(
              issue_id: issue_id,
              user_id: current_user_id,
              journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
              updated_by: current_user_id,
              updated_at: Time.now,
              is_issue_new: is_issue_new ? true : false,
              is_new: true,
              is_viewed: false)
          end
          
          unless Setting.plugin_redmine_notification[:notification_to_assignee].blank?
            if context[:issue].assigned_to.present?
              assigned_id = context[:issue].assigned_to.id
              
              if context[:issue].assigned_to.type == 'Group'
                members = Group.where('id = ?', assigned_id).first.users.where('status = ?', 1).select(:id)
                
                members.each do |member|
                  if !user_ids.include?(member.id)
                    user_ids.push(member.id)
                    
                    IssueNotification.create(
                        issue_id: issue_id,
                        user_id: member.id,
                        journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
                        updated_by: current_user_id,
                        updated_at: Time.now,
                        is_issue_new: is_issue_new ? true : false,
                        is_new: true,
                        is_viewed: false)
                  end
                end
              elsif context[:issue].assigned_to.type == 'User' && !user_ids.include?(assigned_id)
                user_ids.push(assigned_id)
                
                IssueNotification.create(
                  issue_id: issue_id,
                  user_id: assigned_id,
                  journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
                  updated_by: current_user_id,
                  updated_at: Time.now,
                  is_issue_new: is_issue_new ? true : false,
                  is_new: true,
                  is_viewed: false)
              end
            end
          end
          
          unless Setting.plugin_redmine_notification[:notification_to_watcher].blank?            
            watchers = Watcher.where('watchable_type = ? and watchable_id = ?', 'Issue', issue_id).select(:user_id)
              
            watchers.each do |watcher|
              if !user_ids.include?(watcher.user_id)
                user_ids.push(watcher.user_id)
                
                IssueNotification.create(
                    issue_id: issue_id,
                    user_id: watcher.user_id,
                    journal_id: context[:issue].current_journal.present? ? context[:issue].current_journal.id : nil,
                    updated_by: current_user_id,
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
end