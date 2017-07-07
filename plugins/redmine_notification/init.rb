require 'redmine'
require 'redmine_notification/controller_notification_hook'
require 'redmine_notification/view_notification_hook'
require 'redmine_notification/application_controller_patch'

Redmine::Plugin.register :redmine_notification do
  name 'Redmine Notification plugin'
  author 'Tim.Trinh'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  
  settings :default => {
    :notification_to_creator => false,
    :notification_to_modifier => false,
    :notification_to_assignee => false,
    :notification_to_watcher => false
  }, :partial => 'settings/notification'
  
  menu :top_menu, :redmine_notification, { :controller => 'redmine_notification', :action => 'index' }, :caption => 'Notifications', :last => true
end
