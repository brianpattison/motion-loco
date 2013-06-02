class Comment < ActiveRecord::Base
  attr_accessible :body, :post_id
  belongs_to :post
end
