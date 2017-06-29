class IssueNotification < ActiveRecord::Base
  unloadable
  
  belongs_to :issue, :class_name => 'Issue', :foreign_key => 'issue_id'
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :journal, :class_name => 'Journal', :foreign_key => 'journal_id'
end
