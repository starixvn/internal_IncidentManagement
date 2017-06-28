require_dependency 'application_controller'

module RedmineNotificationHelper
  def count_new_notifications
    @total_new_notifications = IssueNotification.where("user_id = ? OR is_new = true", User.current.id).count
    @total_new_notifications
  end
end

ApplicationController.send(:helper, RedmineNotificationHelper)