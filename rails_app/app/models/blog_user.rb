class BlogUser < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :post_ids
  has_many :posts, foreign_key: :author_id
end
