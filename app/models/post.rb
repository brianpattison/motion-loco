class Post < Loco::Model
  property :title, :string
  property :body, :string
  has_many :comments
end
