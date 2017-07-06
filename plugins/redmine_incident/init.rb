require 'redmine'
require_dependency 'redmine_incident/view_hooks'

Redmine::Plugin.register :redmine_incident do
  name 'Redmine Incident plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
