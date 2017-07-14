require 'redmine'
require 'redmine_incident/view_hooks'
require 'redmine_incident/application_helper_patch'
require 'redmine_incident/gantt_helper_patch'
require 'redmine_incident/issues_helper_patch'
require 'redmine_incident/search_helper_patch'
require 'redmine_incident/issues_controller_patch' 

Redmine::Plugin.register :redmine_incident do
  name 'Redmine Incident plugin'
  author 'Tim.Trinh'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end