class IssueNotification < ActiveRecord::Base
  unloadable
  
  belongs_to :issue, :class_name => 'Issue', :foreign_key => 'issue_id'
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :detail, :class_name => 'JournalDetail', :foreign_key => 'journal_detail_id'
end
