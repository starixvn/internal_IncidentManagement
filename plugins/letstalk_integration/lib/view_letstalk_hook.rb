class LetstalkHook < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, :partial => "/letstalk_form"
end