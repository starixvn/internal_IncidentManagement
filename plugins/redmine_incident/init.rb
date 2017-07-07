require 'redmine'
require 'redmine_incident/view_hooks'

Redmine::Plugin.register :redmine_incident do
  name 'Redmine Incident plugin'
  author 'Tim.Trinh'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end
