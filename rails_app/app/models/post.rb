class Post < ActiveRecord::Base
  attr_accessible :body, :title, :comment_ids
  has_many :comments
end
