require 'redmine'

Redmine::Plugin.register :redmine_notification do
  name 'Redmine Notification plugin'
  author 'Tim.Trinh'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  
  menu :top_menu, :redmine_notification, { :controller => 'redmine_notification', :action => 'index' }, :caption => 'Notifications', :last => true
end
