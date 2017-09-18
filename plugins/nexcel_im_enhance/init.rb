require 'layout_header_hook'
require 'view_issues_form_details_bottom_hook'
require 'view_issues_index_bottom_hook'
require 'application_helper_patch'
require 'view_issues_show_details_bottom_hook'

Redmine::Plugin.register :nexcel_im_enhance do
  name 'Nexcel Redmine Enhance plugin'
  author 'Hunter.Tran'
  description 'This is a plugin for fix bugs and enhance in Redmine Nexdev'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  requires_redmine :version_or_higher => '3.3.3'
end
