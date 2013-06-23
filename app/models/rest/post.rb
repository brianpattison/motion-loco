class Post < Loco::Model
  adapter 'Loco::RESTAdapter', 'http://localhost:3000'
  property :title, :string
  property :body, :string
  has_many :comments
end
