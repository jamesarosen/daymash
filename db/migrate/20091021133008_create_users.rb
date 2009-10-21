class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.string :username,           :limit => 256, :null => false
      t.string :email,              :limit => 256, :null => false
      t.string :display_name,       :limit => 256
      t.string :crypted_password,   :limit => 256
      t.string :password_salt,      :limit => 64
      t.string :persistence_token,  :limit => 256
      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email
    add_index :users, :persistence_token
  end

  def self.down
    drop_table :users
  end
  
end
