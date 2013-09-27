class Post < ActiveRecord::Base
  attr_accessible :body, :title, :author_id, :comment_ids
  belongs_to :author, class_name: BlogUser
  has_many :comments
end
