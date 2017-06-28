class CreateIssueNotifications < ActiveRecord::Migration  
  def self.up
    create_table :issue_notifications do |t|
      t.integer :issue_id
      t.integer :user_id
      t.integer :journal_id
      t.boolean :is_new, :default => false
      t.boolean :is_viewed, :default => false
    end
    add_index :issue_notifications, [:issue_id, :user_id, :journal_id]
  end
  
  def self.down
    drop_table :issue_notifications
  end
end
