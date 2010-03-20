class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.string :email,              :limit => 256, :null => false
      t.string :display_name,       :limit => 256
      t.string :persistence_token,  :limit => 256
      t.string :privacy_token,      :limit => 256, :null => false
      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :persistence_token
    
    create_table :credentials do |t|
      t.string  :provider,          :limit => 64, :null => false
      t.string  :identifier,        :limit => 256, :null => false
      t.integer :user_id,           :null => false
    end
    add_index :credentials, :user_id
    add_index :credentials, [:identifier, :provider, :user_id], :unique => true
    
    ActsAsArchive.update Credential
  end

  def self.down
    drop_table :archived_credentials
    drop_table :credentials
    drop_table :users
  end
  
end
