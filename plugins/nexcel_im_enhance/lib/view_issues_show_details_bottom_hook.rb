class ViewIssuesShowDetailsBottomListener < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, :partial => "view_issues_show_details_bottom/view_issues_show_details_bottom"
end