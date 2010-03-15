class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.string :uri,      :limit => 256, :null => false
      t.string :title,    :limit => 256, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :calendars, :user_id
    add_index :calendars, :uri
    add_index :calendars, [:user_id, :title]
    add_index :calendars, [:user_id, :uri], :unique => true
  end

  def self.down
    drop_table :calendars
  end
end
