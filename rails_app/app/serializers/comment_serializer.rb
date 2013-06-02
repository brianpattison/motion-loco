class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :body
  has_one :post, embed: :ids, include: true
end
