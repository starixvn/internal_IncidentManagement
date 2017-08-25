class RedmineIncidentHook < Redmine::Hook::ViewListener
  render_on :view_layouts_base_body_bottom, :partial => '/issue_table_guide'
  
  def view_layouts_base_html_head(context={})
    return "\n".html_safe + stylesheet_link_tag('select2.min.css', :plugin => 'redmine_incident') +
      "\n".html_safe + stylesheet_link_tag('issues_form.css', :plugin => 'redmine_incident')
      "\n".html_safe + stylesheet_link_tag('application.css', :plugin => 'redmine_incident')
      "\n".html_safe + stylesheet_link_tag('themes_alternate.css', :plugin => 'redmine_incident')

  end
      
  def view_layouts_base_body_bottom(context={})
    return javascript_include_tag('layout_enhance.js', :plugin => 'redmine_incident')
  end
  
  def view_issues_form_details_bottom(context={})
    return "\n".html_safe + javascript_include_tag('issues_form.js', :plugin => 'redmine_incident') +
      "\n".html_safe + javascript_include_tag('select2.full.min.js', :plugin => 'redmine_incident')
  end
end