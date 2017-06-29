class CreateIssueNotifications < ActiveRecord::Migration  
  def self.up
    create_table :issue_notifications do |t|
      t.integer :issue_id, null: false
      t.integer :user_id, null: false
      t.integer :journal_id, null: false
      t.integer :updated_by, null: false
      t.boolean :is_new, :default => true
      t.boolean :is_viewed, :default => false
    end
    add_index :issue_notifications, [:issue_id, :user_id, :journal_id], :unique => true, :name => 'issue_notification_index'
  end
  
  def self.down
    drop_table :issue_notifications
  end
end
