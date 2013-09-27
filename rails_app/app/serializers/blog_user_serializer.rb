class BlogUserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name
  has_many :posts, embed: :ids
end
