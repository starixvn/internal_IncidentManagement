class SearchAssigneeHook < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, :partial => "/search_assignee"
end

class ViewHooks < Redmine::Hook::ViewListener  
  def view_layouts_base_body_bottom(context={})
    return javascript_include_tag('layout_enhance.js', :plugin => 'redmine_incident')
  end
end