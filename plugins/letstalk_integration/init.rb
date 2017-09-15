require 'redmine'
require 'controller_letstalk_hook'
require 'view_letstalk_hook'

Redmine::Plugin.register :letstalk_integration do
  name 'Letstalk Integration plugin'
  author 'Terry.Nguyen'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end