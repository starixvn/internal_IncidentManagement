class RedmineNotificationHook < Redmine::Hook::ViewListener
  render_on :view_layouts_base_body_bottom, :partial => '/total_new_notifications'    
end

class RedmineNotificationViewsLayoutsHook < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context={})
    return stylesheet_link_tag('redmine_notification.css', :plugin => 'redmine_notification')
  end
end
