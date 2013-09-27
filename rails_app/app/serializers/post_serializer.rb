class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  has_one :author, embed: :ids, include: true
  has_many :comments, embed: :ids, include: true
end
