class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  has_many :comments, embed: :ids, include: true
end
