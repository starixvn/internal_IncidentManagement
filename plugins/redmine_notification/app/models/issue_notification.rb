class IssueNotification < ActiveRecord::Base
  unloadable
  
  belongs_to :issue, :class_name => 'Issue', :foreign_key => 'issue_id'
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
end
