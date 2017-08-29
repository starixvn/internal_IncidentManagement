class CreateIssueNotifications < ActiveRecord::Migration  
  def self.up
    create_table :issue_notifications do |t|
      t.integer :issue_id, :null => false
      t.integer :user_id, :null => false
      t.integer :updated_by, :null => false
      t.datetime :updated_at, :null => false
      t.integer :journal_id
      t.boolean :is_issue_new, :default => false
      t.boolean :is_new, :default => true
      t.boolean :is_viewed, :default => false
    end
    add_index :issue_notifications, [:issue_id, :user_id], :name => 'issue_notification_index'
  end
  
  def self.down
    drop_table :issue_notifications
  end
end
