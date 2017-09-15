class ViewIssuesIndexBottomListener < Redmine::Hook::ViewListener
    render_on :view_issues_index_bottom, :partial => "view_issues_index_bottom/view_issues_index_bottom"
end