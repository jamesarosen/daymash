class Calendar < ActiveRecord::Base
  
  acts_as_archive
  belongs_to :user, :touch => true
  validates_presence_of :uri, :title, :user
  validates_format_of :uri, :with => /^https?:\/\/.+\..+/
  validates_uniqueness_of :uri, :title, :scope => :user_id
  
end

Calendar::Archive.class_eval do
  
  # Finds a deleted Calendar for the given user with the given ID.
  #
  # @param [User] user
  # @param [Fixnum] id
  # @return [Calendar::Archive] a deleted calendar
  # @raise [ActiveRecord::RecordNotFound] if user has no such deleted calendar
  def self.find_by_user_and_id!(user, id)
    returning(find_by_user_id_and_id(user, id)) do |c|
      raise ActiveRecord::RecordNotFound.new("User ##{user_id} has no deleted calendar ##{id}") unless c
    end
  end
  
  def restore
    Calendar.restore_all(['id = ?', id])
    Calendar.find(id)
  end
end
